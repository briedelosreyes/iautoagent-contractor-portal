-- Every fixture, payment record, and audit event below is rolled back.
begin;
do $test$
declare
  actor uuid;
  period_id uuid;
  contractor uuid;
  run_id uuid := gen_random_uuid();
  first_item uuid := gen_random_uuid();
  second_item uuid := gen_random_uuid();
  result jsonb;
  blocked boolean;
begin
  select id into actor from public.profiles where lower(email)='brie@iautoagent.com';
  if actor is null then raise exception 'Test actor missing'; end if;
  perform set_config('request.jwt.claim.sub',actor::text,true);
  perform set_config('request.jwt.claim.role','authenticated',true);
  perform set_config('request.jwt.claims',jsonb_build_object('sub',actor,'role','authenticated')::text,true);
  select id into period_id from public.car_concierge_payroll_periods limit 1;
  select concierge_id into contractor from public.car_concierge_payroll_items limit 1;
  insert into public.car_concierge_payroll_runs(id,payroll_period_id,run_number,status,reviewed_by_profile_id,reviewed_at,total_payroll_amount)
    select run_id,period_id,coalesce(max(run_number),0)+1,'approved_for_payout',actor,now(),3
    from public.car_concierge_payroll_runs where payroll_period_id=period_id;
  insert into public.car_concierge_payroll_items(id,payroll_run_id,concierge_id,status,gross_pay)
    values(first_item,run_id,contractor,'approved',1),(second_item,run_id,actor,'approved',2);

  blocked:=false;
  begin perform public.record_car_concierge_payroll_item_payment(first_item,current_date,'TEST',99);
  exception when others then blocked:=true; end;
  if not blocked then raise exception 'Amount mismatch was accepted'; end if;
  blocked:=false;
  begin perform public.record_car_concierge_payroll_item_payment(first_item,current_date+2,'TEST',1);
  exception when others then blocked:=true; end;
  if not blocked then raise exception 'Future payment was accepted'; end if;
  blocked:=false;
  begin update public.car_concierge_payroll_items set gross_pay=4 where id=first_item;
  exception when others then blocked:=true; end;
  if not blocked then raise exception 'Finalized amount edit was accepted'; end if;

  result:=public.record_car_concierge_payroll_item_payment(first_item,(now() at time zone 'America/Chicago')::date,'TEST external check 1',1);
  if result->>'status'<>'paid' or (result->>'run_paid')::boolean then raise exception 'Partial payment result incorrect'; end if;
  if (select status from public.car_concierge_payroll_runs where id=run_id)<>'approved_for_payout' then raise exception 'Run finalized prematurely'; end if;
  blocked:=false;
  begin perform public.record_car_concierge_payroll_item_payment(first_item,current_date,'TEST duplicate',1);
  exception when others then blocked:=true; end;
  if not blocked then raise exception 'Duplicate payment was accepted'; end if;

  result:=public.record_car_concierge_payroll_item_payment(second_item,(now() at time zone 'America/Chicago')::date,'TEST external check 2',2);
  if not (result->>'run_paid')::boolean or (select status from public.car_concierge_payroll_runs where id=run_id)<>'paid' then raise exception 'Run not marked paid'; end if;
  if (select count(*) from public.car_concierge_payroll_events where payroll_run_id=run_id)<>4 then raise exception 'Payment audit trail incomplete'; end if;
  blocked:=false;
  begin update public.car_concierge_payroll_items set ach_reference='changed' where id=first_item;
  exception when others then blocked:=true; end;
  if not blocked then raise exception 'Paid reference edit was accepted'; end if;

  perform set_config('request.jwt.claim.sub','',true);
  perform set_config('request.jwt.claims','{"role":"anon"}',true);
  blocked:=false;
  begin perform public.record_car_concierge_payroll_item_payment(second_item,current_date,'TEST unauthenticated',2);
  exception when others then blocked:=true; end;
  if not blocked then raise exception 'Unauthenticated payment was accepted'; end if;
  if has_function_privilege('anon','public.record_car_concierge_payroll_item_payment(uuid,date,text,numeric)','EXECUTE') then raise exception 'Anonymous execution enabled'; end if;
end;
$test$;
rollback;
select 'PASS: payment recording, partial/full totals, audit trail, authorization, amount protection, duplicate rejection and immutability; all test writes rolled back.' as verification;
