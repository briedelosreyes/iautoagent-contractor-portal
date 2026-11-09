-- Record an external contractor payment. This does not send money.
begin;

create or replace function public.protect_finalized_car_concierge_payroll_item()
returns trigger language plpgsql set search_path to 'public' as $function$
declare
  v_run_id uuid;
  v_run_status text;
begin
  v_run_id := case when tg_op = 'DELETE' then old.payroll_run_id else new.payroll_run_id end;
  select status into v_run_status from public.car_concierge_payroll_runs where id = v_run_id;
  if v_run_status in ('approved_for_payout','ach_payout_initiated','paid') then
    -- Permit payment metadata only; finalized amounts and source links stay locked.
    if tg_op = 'UPDATE' and v_run_status <> 'paid'
       and old.status in ('approved','ach_initiated') and new.status = 'paid'
       and new.paid_at is not null and nullif(btrim(new.ach_reference),'') is not null
       and (to_jsonb(new) - array['status','paid_at','ach_reference','updated_at'])
           = (to_jsonb(old) - array['status','paid_at','ach_reference','updated_at']) then
      return new;
    end if;
    raise exception 'Payroll items in a finalized run cannot be modified or deleted.';
  end if;
  return case when tg_op = 'DELETE' then old else new end;
end;
$function$;

create or replace function public.record_car_concierge_payroll_item_payment(
  p_payroll_item_id uuid, p_paid_date date, p_payment_reference text,
  p_expected_amount numeric
) returns jsonb language plpgsql security definer set search_path to '' as $function$
declare
  v_actor uuid := auth.uid();
  v_role text := public.get_car_concierge_payroll_actor_role();
  v_run public.car_concierge_payroll_runs%rowtype;
  v_item public.car_concierge_payroll_items%rowtype;
  v_run_id uuid;
  v_paid_at timestamptz;
  v_reference text := nullif(btrim(p_payment_reference),'');
  v_remaining integer;
begin
  if v_actor is null or v_role is null or v_role not in ('client_services_director','payroll_team') then
    raise exception 'You are not authorized to record payroll payments.';
  end if;
  if p_paid_date is null or p_paid_date > (now() at time zone 'America/Chicago')::date then
    raise exception 'Enter a payment date that is today or earlier.';
  end if;
  if v_reference is null or length(v_reference) > 300 then
    raise exception 'Enter a payment method and reference (up to 300 characters).';
  end if;
  select payroll_run_id into v_run_id from public.car_concierge_payroll_items where id=p_payroll_item_id;
  if not found then raise exception 'Payroll item not found.'; end if;
  -- Serialize payment recording per run, including concurrent contractor payments.
  select * into v_run from public.car_concierge_payroll_runs where id=v_run_id for update;
  select * into v_item from public.car_concierge_payroll_items where id=p_payroll_item_id for update;
  if v_item.status='paid' then raise exception 'This contractor payment is already recorded.'; end if;
  if v_run.status not in ('approved_for_payout','ach_payout_initiated')
     or v_item.status not in ('approved','ach_initiated') then
    raise exception 'Payroll must be approved before payment can be recorded.';
  end if;
  if p_expected_amount is null or v_item.gross_pay is distinct from p_expected_amount or v_item.gross_pay <= 0 then
    raise exception 'The payroll amount changed or is not payable. Refresh and review it again.';
  end if;
  v_paid_at := p_paid_date::timestamp at time zone 'America/Chicago';
  update public.car_concierge_payroll_items
    set status='paid', paid_at=v_paid_at, ach_reference=v_reference where id=v_item.id;
  perform public.write_car_concierge_payroll_event(v_run.id,v_item.id,'payroll_item_paid',
    v_item.status,'paid',v_actor,v_role,v_item.gross_pay,'External payment recorded.',
    jsonb_build_object('payment_reference',v_reference,'paid_date',p_paid_date,'recorded_at',now(),'money_sent_by_portal',false));
  select count(*) into v_remaining from public.car_concierge_payroll_items where payroll_run_id=v_run.id and status<>'paid';
  if v_remaining=0 then
    -- Respect the existing approved -> initiated -> paid state machine.
    if v_run.status='approved_for_payout' then
      update public.car_concierge_payroll_runs set status='ach_payout_initiated',
        ach_initiated_by_profile_id=v_actor,ach_initiated_at=now(),
        ach_reference='External payments recorded; see contractor payment references.' where id=v_run.id;
      perform public.write_car_concierge_payroll_event(v_run.id,null,'payroll_external_payments_recorded',
        v_run.status,'ach_payout_initiated',v_actor,v_role,v_run.total_payroll_amount,
        'All external contractor payments recorded; no transfer initiated by portal.',jsonb_build_object('money_sent_by_portal',false));
    end if;
    select max(paid_at) into v_paid_at from public.car_concierge_payroll_items where payroll_run_id=v_run.id;
    update public.car_concierge_payroll_runs set status='paid',paid_at=v_paid_at,paid_by_profile_id=v_actor where id=v_run.id;
    perform public.write_car_concierge_payroll_event(v_run.id,null,'payroll_run_paid',
      'ach_payout_initiated','paid',v_actor,v_role,v_run.total_payroll_amount,
      'All contractor payments recorded.',jsonb_build_object('recorded_at',now(),'money_sent_by_portal',false));
  end if;
  return jsonb_build_object('ok',true,'payroll_item_id',v_item.id,'status','paid','run_paid',v_remaining=0);
end;
$function$;

revoke all on function public.record_car_concierge_payroll_item_payment(uuid,date,text,numeric) from public, anon;
grant execute on function public.record_car_concierge_payroll_item_payment(uuid,date,text,numeric) to authenticated;
commit;
