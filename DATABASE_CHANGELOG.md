# iAutoAgent Contractor Portal — Database Change Log

This file tracks every production database change made to the iAutoAgent Contractor Portal.

## Status Key

- `Planned` — approved but not yet run
- `Applied` — successfully run in Supabase
- `Verified` — applied and confirmed through testing
- `Rolled Back` — reversed after deployment
- `Superseded` — replaced by a later query

## Change-Control Rules

1. Every SQL script must have a unique sequential query number.
2. The SQL Editor query name must match the title used in this file.
3. Never reuse a query number.
4. Record the date applied and the person who ran it.
5. Record verification results before marking a change `Verified`.
6. Do not edit an already-applied migration to change history. Create a new numbered query instead.
7. Keep rollback notes when a change can be safely reversed.
8. Database permissions, RLS policies, triggers, functions, tables, columns, indexes, and data corrections must all be documented.

---

## Migration Register

| Query | Title | Category | Status | Date Applied | Applied By |
|---:|---|---|---|---|---|
| 1–22 | Existing Portal Foundation | Legacy | Applied | Before changelog | Existing implementation |
| 23 | Fix Jay Profile Email | Data correction | Applied | 2026-07 | Brie |
| 24 | Verify Jay Profile | Verification | Applied | 2026-07 | Brie |
| 25 | Inspect Profile Roles Columns | Inspection | Applied | 2026-07 | Brie |
| 26 | Verify Jay Profile and Roles | Verification | Applied | 2026-07 | Brie |
| 27 | Grant Service Role Access to Notification Outbox | Permissions | Applied | 2026-07 | Brie |
| 28 | Grant Service Role Access to Contractor Portal Tables | Permissions | Applied | 2026-07 | Brie |
| 29 | Assignment, Cost, and Completion Schema Inspection | Inspection | Completed | 2026-07-18 | Brie |
| 30 | Assignment Lifecycle and Payroll Foundation | Schema | Applied | 2026-07-18 | Brie |
| 31 | Assignment Event and Lifecycle Automation | Functions and Triggers | Applied | 2026-07-18 | Brie |
| 32 | Payroll Calculation and Approval Functions | Functions | Verified | 2026-07-18 | Brie |
| 33 | Role Model and Access Policies | Security | Applied | 2026-07-18 | Brie |
| 34 | User Archiving and Commission Eligibility | User Management and Security | Verified | 2026-07-18 | Brie Delos Reyes |
| 35 | Open Assignment Pool and Atomic Claiming | Assignment Automation | Fully Verified | 2026-07-19 | Brie Delos Reyes |
| 35E | Add General Area to Open Assignment Pool | Privacy and Portal UI | Verified | 2026-07-19 | Brie Delos Reyes |
| 35G | Synchronize Reassigned Client Calendar Titles | Calendar Automation | Verified | 2026-07-19 | Brie Delos Reyes |
| 35I | Automatic Assignment Acceptance Notifications | Notification Automation | Verified | 2026-07-19 | Brie Delos Reyes |
| 35J | Backfill Assignment #8 Acceptance Confirmation | Data Correction | Completed | 2026-07-19 | Brie Delos Reyes |
| 36A | Calendar Synchronization Architecture Foundation | Calendar Automation | Verified | 2026-07-22 | Brie Delos Reyes |
| 36A.2 | Calendar Queue and Registry Foundation | Calendar Automation | Verified | 2026-07-22 | Brie Delos Reyes |
| 36B | Calendar Worker Queue Processing Foundation | Calendar Automation | Verified | 2026-07-22 | Brie Delos Reyes |
| 36C.1 | Calendar Create Synchronization | Calendar Automation | Verified | 2026-07-22 | Brie Delos Reyes |
| 36C.2 | Calendar Update Synchronization | Calendar Automation | Verified | 2026-07-22 | Brie Delos Reyes |
| 36C.3 | Calendar Cancel Synchronization | Calendar Automation | Verified | 2026-07-22 | Brie Delos Reyes |
| 36C.4 | Calendar Queue Idempotency and Retry Integration | Calendar Automation | Verified | 2026-07-22 | Brie Delos Reyes |
| 36D.1 | Calendar Registry Protection | Calendar Security | Verified | 2026-07-22 | Brie Delos Reyes |
| 36D.2 | Calendar Queue Validation and Processing Controls | Calendar Security | Verified | 2026-07-22 | Brie Delos Reyes |
| 36D.3 | Portal Role Compatibility Correction | Security | Verified | 2026-07-22 | Brie Delos Reyes |
| 36D.5 | Calendar Queue Reliability Improvements | Calendar Automation | Verified | 2026-07-22 | Brie Delos Reyes |
| 36D.6 | Calendar Worker Service Role Permission Support | Permissions | Verified | 2026-07-22 | Brie Delos Reyes |
| 36D.7 | Calendar Worker Payroll Permission Support | Permissions | Verified | 2026-07-22 | Brie Delos Reyes |
| 36D.10 | Calendar Registry Append-Only Audit Compatibility Fix | Calendar Security | Verified | 2026-07-22 | Brie Delos Reyes |
| 36D.11 | Car Concierge Payroll Items Service Role Permission Fix | Permissions | Verified | 2026-07-23 | Brie Delos Reyes |
| 36D.12 | Car Concierge Payroll Runs Service Role Permission Fix | Permissions | Verified | 2026-07-23 | Brie Delos Reyes |
| 37 | Payroll Notification Outbox Events | Automation | Planned | — | — |

------

# Detailed Change Records

## Queries 1–22 — Existing Portal Foundation

**Status:** Applied  
**Category:** Legacy  
**Date applied:** Before this changelog was created

These queries established the original contractor portal database, including the core assignment, appointment, profile, role, cost, completion, response-history, listing-agent, showing, closing, and notification structures.

The individual titles and exact execution dates were not captured in this changelog. Do not assign invented descriptions retroactively. Add details only when confirmed from Supabase SQL history or existing project records.

---

## Query 23 — Fix Jay Profile Email

**Status:** Applied  
**Category:** Data correction

### Purpose

Correct Jay's profile email so the portal and calendar automation can resolve the proper linked user profile.

### Verification

- Jay's profile returned the intended email address.
- The linked profile could be retrieved successfully.

### Rollback

Restore the prior email only if the corrected address is proven inaccurate.

---

## Query 24 — Verify Jay Profile

**Status:** Applied  
**Category:** Verification

### Purpose

Confirm Jay's profile record after the email correction.

### Database impact

Read-only inspection. No persistent schema or data changes.

---

## Query 25 — Inspect Profile Roles Columns

**Status:** Applied  
**Category:** Inspection

### Purpose

Inspect the structure of `profile_roles` before making role-related changes.

### Database impact

Read-only inspection. No persistent schema or data changes.

---

## Query 26 — Verify Jay Profile and Roles

**Status:** Applied  
**Category:** Verification

### Purpose

Confirm Jay's profile and assigned roles after the profile correction.

### Database impact

Read-only inspection. No persistent schema or data changes.

---

## Query 27 — Grant Service Role Access to Notification Outbox

**Status:** Applied  
**Category:** Permissions

### Purpose

Grant the Supabase service role the required access to `contractor_notification_outbox`.

### Reason

The calendar and notification Edge Function could not read or process notification records because of table permission errors.

### Verification

The original notification-outbox permission error stopped appearing.

### Security note

This permission is intended for trusted server-side execution using the service role. It must not expand anonymous or ordinary authenticated-user access.

---

## Query 28 — Grant Service Role Access to Contractor Portal Tables

**Status:** Applied  
**Category:** Permissions

### Purpose

Grant the Supabase service role access to the contractor portal tables required by the calendar and notification Edge Functions.

### Covered objects

- `car_concierge_assignments`
- `appointments`
- `assignment_types`
- `listing_agents`
- `showing_details`
- `closing_details`
- `completion`
- `response_history`
- `costs`
- `contractor_notification_outbox`
- `profiles`
- `profile_roles`
- Related sequences

### Reason

The Edge Function returned:

`permission denied for table car_concierge_assignments`

### Verification

The permission error was resolved. The later missing pickup invitation was confirmed to have been caused by an incorrectly entered appointment date rather than a database or calendar-sync defect.

### Security note

Service-role permissions must remain server-side only.

---

## Query 29 — Inspect Steve Assignment Calendar Sync

**Status:** Not required  
**Category:** Inspection

### Purpose

This query was prepared to inspect pickup and drop-off calendar synchronization for Steve's latest assignment.

### Outcome

The query was not required because the missing calendar event was caused by an incorrectly entered date.

### Database impact

None.

---

# Approved Version 1 Foundation

## Query 30 — Assignment Lifecycle and Payroll Foundation

**Status:** Planned  
**Category:** Schema

### Planned scope

Add assignment-level fields for:

- Cancellation timestamp
- Canceling user and role
- Cancellation reason and notes
- Scheduled pickup time snapshot
- Late-cancellation eligibility
- Cancellation-pay hours
- Cancellation-pay amount
- Payroll status
- Payroll-period dates
- Completion notification status
- Payment lifecycle timestamps
- Supporting indexes

### Business rules

- Cancellation less than 60 minutes before pickup earns one hour of pay.
- Cancellation exactly 60 minutes before pickup earns no cancellation pay.
- Deleted mistaken assignments never create cancellation pay.
- Calculations must use authoritative database timestamps and Central Time display rules.

---

## Query 31 — Assignment Timeline and Internal Notes

**Status:** Planned  
**Category:** Schema

### Planned objects

Create an assignment activity timeline supporting:

- Assignment creation
- Assignment release
- Acceptance or decline
- Calendar synchronization
- Appointment activity
- Additional-cost submissions and decisions
- Completion
- Cancellation
- Late-cancellation pay
- Payroll approval
- ACH payout initiation
- Paid status
- Internal timestamped notes

### Required fields

- Assignment ID
- Event type
- Event timestamp
- Actor user ID
- Actor name
- Actor role
- Previous value or status
- New value or status
- Amount, when applicable
- Notes
- Structured metadata

---

## Query 32 — Payroll Batches and Approval Workflow

**Status:** Planned  
**Category:** Schema

### Planned objects

- `payroll_batches`
- `contractor_payouts`
- `contractor_payout_items`
- Payroll audit or timeline records

### Payroll period rules

- First period: 1st through 15th
- Second period: 16th through the last calendar day of the month
- Completed assignment inclusion date: completion date
- Late-cancellation inclusion date: cancellation date
- Approved additional-cost inclusion date: approval date unless later policy specifies otherwise

### Workflow

1. Payroll Team generates a projected contractor payout.
2. Status becomes `Pending Client Services Approval`.
3. Client Services Director receives an approval email.
4. Client Services Director approves, rejects, or places it on hold.
5. The Payroll Team member who submitted it receives the decision email.
6. Payroll records ACH payout initiation.
7. Payroll later marks the payout paid.

### ACH rule

ACH is the only payout method. The system must not require payout-method selection.

---

## Query 33 — Role Model and Access Policies

**Status:** Planned  
**Category:** Security

### Roles

- CEO
- Client Services Director
- Payroll Team
- Listing Agent
- Car Concierge

### Key permission rules

#### CEO

- Executive visibility across assignments, payroll, audit records, and reporting
- May approve payroll when authorized
- May place payouts on hold
- May perform emergency assignment cancellation
- Does not receive routine operational controls by default

#### Client Services Director

- Full assignment operations
- Assignment cancellation
- Mistaken-assignment deletion
- Cost approval
- Payroll approval
- Operational filters and reporting

#### Payroll Team

- Generate projected payouts
- Submit projections for approval
- Record ACH initiation
- Mark payouts paid
- Cannot modify assignment hours, rates, cancellation eligibility, or cost approvals

#### Listing Agent

- View linked assignments and showings
- Receive applicable calendar invitations and completion notices
- Cancel only a showing personally booked by that Listing Agent
- Cannot delete assignments or alter payroll

#### Car Concierge

- View and act on their own assignments
- Accept or decline
- Complete assignments
- Submit additional-cost requests
- View projected pay
- Cannot cancel or delete assignments

---

## Query 34 — Cancellation and Late-Pay Engine

**Status:** Planned  
**Category:** Functions

### Planned behavior

- Validate cancellation authority server-side.
- Record the canceling user, role, timestamp, and reason.
- Compare cancellation timestamp with scheduled pickup start.
- Apply one hour of pay only when cancellation occurs less than 60 minutes before pickup.
- Preserve canceled assignments for audit and payroll history.
- Cancel related Google Calendar events.
- Queue cancellation notifications.
- Prevent duplicate cancellation processing.

### Listing Agent rule

A Listing Agent may cancel only a showing they personally booked.

---

## Query 35 — Completion and Cost Notification Tracking

**Status:** Planned  
**Category:** Schema

### Completion notifications

When any assignment is completed:

- Notify the Client Services Director.
- Notify the connected Listing Agent, when applicable.
- Record delivery status, recipients, timestamp, and errors.
- Prevent duplicate sends.
- Support safe retry after failure.

### Additional-cost notifications

When a Car Concierge submits a cost request:

- Notify the Client Services Director.
- Keep the requested amount out of projected pay until approved.
- Record requested, approved, denied, or canceled status.
- Preserve reviewer, review timestamp, approved amount, and notes.

---

## Query 36 — Assignment Deletion Audit

**Status:** Planned  
**Category:** Schema

### Purpose

Support permanent deletion of assignments created by mistake without losing the reason for missing assignment numbers.

### Deletion rules

Only the Client Services Director may permanently delete an eligible assignment.

Deletion is intended for:

- Duplicate entries
- Test records
- Wrong-client records
- Other mistaken entries that should never have existed

Deletion must not be used instead of cancellation.

### Audit fields

- Assignment number
- Assignment type
- Client or vehicle reference
- Previous status
- Car Concierge
- Listing Agent
- Deleted by
- Deleted timestamp
- Deletion reason
- Calendar cleanup result

---

## Query 37 — Payroll Notification Outbox Events

**Status:** Planned  
**Category:** Automation

### Planned notifications

| Trigger | Recipient |
|---|---|
| Projected payout submitted | Client Services Director |
| Projection approved | Submitting Payroll Team member |
| Projection rejected | Submitting Payroll Team member |
| Projection placed on hold | Submitting Payroll Team member |
| Projection revised and resubmitted | Client Services Director |

### Requirements

- Duplicate protection
- Delivery status
- Sent timestamp
- Recipient tracking
- Error logging
- Retry support

---

# Deployment Checklist Template

Use this checklist for every schema-changing query.

## Before running

- [ ] Query number and title match this changelog
- [ ] SQL reviewed for destructive statements
- [ ] Existing columns and constraints inspected
- [ ] RLS and grants reviewed
- [ ] Backup or rollback plan documented where necessary
- [ ] Query tested in a safe environment when practical

## After running

- [ ] Supabase reported success
- [ ] New tables or columns confirmed
- [ ] Existing portal still loads
- [ ] Existing assignment acceptance still works
- [ ] Calendar synchronization still works
- [ ] Notifications still work
- [ ] Role access tested
- [ ] Changelog status updated
- [ ] Date and operator recorded

---

# Verification Log

| Date | Query | Test performed | Result | Verified by |
|---|---:|---|---|---|
| 2026-07 | 27 | Notification outbox permission test | Passed | Brie |
| 2026-07 | 28 | Assignment retrieval and calendar-sync permission test | Passed | Brie |
| 2026-07 | 29 | Calendar issue review | Query unnecessary; incorrect date identified | Brie |

---

# Rollback Log

| Date | Query | Reason | Rollback action | Result |
|---|---:|---|---|---|
| — | — | No rollbacks recorded | — | — |

---

# Notes

- The migration register is the authoritative sequence for future SQL query numbering.
- The latest verified migration is `36D.12`.
- The next available migration number is `36D.13`.
- Inspection queries remain documented even when they do not modify the database.
- Do not mark planned queries as applied until they have been successfully run in Supabase.

- ---

## Query 30 — Assignment Lifecycle and Payroll Foundation

**Status:** Completed successfully  
**Completed:** July 18, 2026 at 4:55:09 AM UTC

### Purpose

Created the database foundation for the Car Concierge assignment lifecycle, cancellation compensation, additional-cost review, assignment history, and payroll processing.

### Changes completed

- Added assignment cancellation tracking
- Confirmed `scheduled_start_at` as the official pickup appointment time
- Added late-cancellation pay fields
- Added one-hour cancellation-pay support for cancellations made less than 60 minutes before pickup
- Added completion-notification tracking
- Added payroll hold fields
- Added partial approval support for contractor cost requests
- Added cost cancellation support
- Created assignment event history
- Created internal assignment notes
- Created permanent assignment-deletion audit storage
- Created payroll periods
- Created payroll runs
- Created contractor payroll summaries
- Created payroll line items
- Created payroll event history
- Added supporting constraints, foreign keys, indexes, and verification checks

### Existing data preserved

The migration preserved the existing assignment, completion, and cost records.

The existing cancelled assignment was backfilled with legacy cancellation details so the new validation rules could be applied safely.

### Execution result

Query 30 completed successfully
2026-07-18 04:55:09.935477+00

---

## Query 31 — Assignment Event and Lifecycle Automation

**Status:** Applied  
**Category:** Functions and Triggers  
**Applied Date:** 2026-07-18  
**Applied By:** Brie  

### Summary

Implemented the assignment event and lifecycle automation layer that connects the Query 30 foundation tables to the existing Car Concierge assignment workflow.

This migration preserved the existing acceptance, decline, reassignment, start, end, completion, and calendar functions while adding centralized timeline logging and lifecycle processing.

### Schema changes

Added the following immutable cancellation calculation field to `car_concierge_assignments`:

- `cancellation_scheduled_start_at_snapshot`

This field preserves the scheduled pickup timestamp used in the cancellation-pay calculation so the result cannot change if the assignment schedule is edited later.

### Functions created

- `get_portal_actor_role(uuid)`
- `write_car_concierge_assignment_event(uuid, text, text, text, uuid, text, numeric, text, jsonb)`
- `prepare_car_concierge_assignment_lifecycle()`
- `log_car_concierge_assignment_lifecycle()`
- `log_car_concierge_cost_event()`
- `log_car_concierge_assignment_note_event()`

### Assignment lifecycle automation

The migration now automatically:

- Records assignment creation
- Records assignment release for acceptance
- Records acceptance and decline
- Records reassignment
- Records assignment start
- Records assignment completion
- Records assignment approval and paid status
- Records cancellation
- Records payroll hold placement and removal
- Records completion-notification outcomes
- Records calendar synchronization and cancellation outcomes

### Cancellation-pay automation

When an assignment first becomes `cancelled`, the system now:

- Records the authoritative cancellation timestamp
- Records the canceling profile when available
- Resolves the cancellation source
- Captures the scheduled pickup timestamp snapshot
- Calculates minutes before scheduled pickup
- Applies the Version 1 late-cancellation policy
- Awards one hour of pay only when cancellation occurs less than 60 minutes before pickup and no later than pickup
- Applies no cancellation pay at exactly 60 minutes before pickup, earlier than 60 minutes, or after pickup
- Stores the hourly-rate snapshot
- Stores the cancellation-pay amount
- Records the policy version as `late-cancellation-v1`
- Creates either a `late_cancellation_pay_applied` or `cancellation_not_payable` timeline event

### Completion notification automation

When an assignment first becomes `completed`, the migration automatically resets and queues completion-notification processing by setting:

- `completion_notification_status = pending`
- `completion_notification_sent_at = null`
- `completion_notification_error = null`
- `completion_notification_attempt_count = 0`
- `completion_notification_last_attempt_at = null`

### Additional-cost timeline automation

The migration now records:

- Additional cost submitted
- Additional cost approved
- Additional cost partially approved
- Additional cost denied
- Additional cost cancelled
- Additional cost returned to pending

Only the approved amount is recorded as payable when a cost is approved.

### Internal-note timeline automation

Adding a record to `car_concierge_assignment_notes` now automatically creates an `internal_note_added` assignment event.

### Triggers created

On `car_concierge_assignments`:

- `car_concierge_assignment_lifecycle_before`
- `car_concierge_assignment_lifecycle_after`

On `car_concierge_costs`:

- `car_concierge_cost_event_logger`

On `car_concierge_assignment_notes`:

- `car_concierge_assignment_note_event_logger`
- `car_concierge_assignment_notes_set_updated_at`

On payroll tables:

- `car_concierge_payroll_periods_set_updated_at`
- `car_concierge_payroll_runs_set_updated_at`
- `car_concierge_payroll_items_set_updated_at`

### Security

Direct execution of the generic assignment event writer was revoked from ordinary public and authenticated roles. Timeline events are intended to be generated through trusted database functions and triggers.

### Verification

The migration verified:

- The cancellation schedule snapshot column exists
- Required lifecycle functions exist
- Assignment lifecycle triggers exist
- Cost event trigger exists
- Assignment-note event trigger exists

### Execution result


Query 31 completed successfully
2026-07-18 05:24:42.732689+00

## Query 32 — Payroll Calculation and Approval Functions

**Status:** Verified  
**Category:** Functions

### Purpose

Implement the Car Concierge payroll engine on top of the payroll tables created by Query 30.

This migration does not create replacement payroll tables and does not recreate assignment acceptance, decline, reassignment, start, completion, cancellation-pay, calendar, validation, or `updated_at` automation.

### Functions added

- `get_car_concierge_semimonthly_period(date)`
- `get_car_concierge_payroll_actor_role()`
- `write_car_concierge_payroll_event(...)`
- `ensure_car_concierge_payroll_period(date, uuid)`
- `rebuild_car_concierge_payroll_run(uuid)`
- `generate_car_concierge_payroll_run(date)`
- `submit_car_concierge_payroll_run(uuid, text)`
- `review_car_concierge_payroll_run(uuid, text, text)`

### Payroll-period rules

- First semimonthly period: 1st through 15th.
- Second semimonthly period: 16th through the final calendar day of the month.
- Business-date interpretation uses the `America/Chicago` time zone.
- Timestamps remain stored as authoritative UTC `timestamptz` values.

### Completed assignment pay

- Includes assignments with status `completed` or `approved`.
- Uses actual `started_at` and `ended_at` timestamps.
- Calculates payable hours from elapsed time.
- Uses the assignment-level hourly-rate snapshot.
- Uses the Central Time date of `ended_at` as the payroll inclusion date.
- Excludes assignments placed on payroll hold.

### Late-cancellation pay

- Includes canceled assignments only when `cancellation_pay_eligible` is true.
- Uses the immutable `cancellation_pay_hours`, `cancellation_pay_rate`, and `cancellation_pay_amount` values written by Query 31.
- Does not recalculate cancellation eligibility or cancellation pay.
- Uses the Central Time date of `cancelled_at` as the payroll inclusion date.
- Excludes assignments placed on payroll hold.

### Approved additional costs

- Includes only cost records with status `approved`.
- Uses only `approved_amount`.
- Supports partial approval.
- Does not use the requested amount when it differs from the approved amount.
- Uses `approved_at`, falling back to `reviewed_at`, as the approval timestamp.
- Uses the Central Time approval date as the payroll inclusion date.
- Excludes costs attached to assignments placed on payroll hold.

### Payroll output

- Creates one payroll item per Car Concierge with eligible payroll sources.
- Creates payroll line items for assignment time, cancellation pay, and approved costs.
- Stores source snapshots in `source_snapshot`.
- Calculates contractor total hours.
- Calculates assignment pay.
- Calculates cancellation pay.
- Calculates approved additional costs.
- Calculates adjustments.
- Calculates gross pay.
- Calculates payroll-run totals.
- Prevents the same assignment-pay, cancellation-pay, or approved-cost source from entering another non-rejected payroll run.

### Payroll workflow

1. An authorized user generates a draft payroll run.
2. The system calculates and itemizes eligible payroll sources.
3. The payroll run is submitted for review.
4. The run changes to `pending_client_services_approval`.
5. The Client Services Director or authorized CEO reviews the run.
6. An approved run changes to `approved_for_payout`.
7. A rejected run changes to `rejected`.
8. A held run changes to `on_hold`.
9. Payroll events preserve an append-only audit trail.

### Authorization

Payroll generation, recalculation, and submission support:

- `payroll_team`
- `admin`
- `client_services_director`
- Trusted `service_role` execution

Payroll review supports:

- `admin`
- `client_services_director`
- Authorized `ceo`
- Trusted `service_role` execution

Query 33 will implement the complete payroll role and RLS policy model.

### Audit behavior

The following actions create records in `car_concierge_payroll_events`:

- Payroll calculation
- Payroll recalculation
- Payroll submission
- Payroll approval
- Payroll rejection
- Payroll hold

### Verification required

- Confirm a date from the 1st through 15th resolves to the correct period.
- Confirm a date from the 16th through month-end resolves to the correct period.
- Generate a run containing a completed assignment.
- Confirm elapsed assignment hours are calculated correctly.
- Confirm assignment pay uses the stored hourly rate.
- Confirm late-cancellation pay uses the immutable Query 31 snapshot.
- Confirm partially approved costs use `approved_amount`.
- Confirm pending, denied, and canceled costs are excluded.
- Confirm payroll-held assignments and their costs are excluded.
- Confirm duplicate sources cannot enter a second active payroll run.
- Submit a payroll run.
- Confirm the run changes to `pending_client_services_approval`.
- Approve a test payroll run.
- Reject a test payroll run.
- Place a test payroll run on hold.
- Confirm unauthorized users cannot calculate or review payroll.
- Confirm payroll events are written for every workflow action.

### Rollback

Drop only the functions created by Query 32.

Do not drop:

- Payroll tables from Query 30
- Assignment lifecycle automation from Query 31
- Assignment event records
- Existing assignment workflow functions
- Existing calendar functions
- Existing validation functions

### Deployment note

Keep Query 32 marked `Planned` until the migration succeeds in Supabase.

After successful execution:

1. Change the status to `Applied`.
2. Add the execution date.
3. Add the person who applied it.
4. Run the verification tests.
5. Change the status to `Verified` only after testing succeeds.

### Verification completed

**Verified:** 2026-07-18  
**Verified by:** Brie

Query 32 passed the controlled payroll-engine verification test.

Confirmed behavior:

- Semimonthly period calculation correctly resolved July 1–15 and July 16–31.
- Completed assignment pay calculated 2.5 hours at $20 per hour for $50.
- Late-cancellation pay used the immutable Query 31 snapshot of 1 hour at $20 for $20.
- Partial cost approval used the approved amount of $15 rather than the requested amount of $25.
- Three payroll line items were generated.
- Contractor gross pay calculated correctly at $85.
- Payroll-run gross total calculated correctly at $85.
- Payroll submission changed the run to `pending_client_services_approval`.
- Payroll hold changed the run to `on_hold`.
- Payroll approval changed the run to `approved_for_payout`.
- Contractor payroll-item status changed to `approved`.
- Four payroll audit events were created.
- All temporary assignments, costs, payroll periods, payroll runs, payroll items, line items, completion records, assignment events, and payroll events were rolled back successfully.


## Query 33 — Role Model and Access Policies

**Status:** Applied  
**Category:** Security

### Purpose

Formalize the approved portal role model and enforce access using stored role assignments, capability functions, table privileges, and Row-Level Security.

### Existing architecture preserved

Query 33 does not recreate assignment, payroll, lifecycle, cancellation, completion, calendar, audit, or notification tables.

The existing tables `portal_role_types`, `profiles`, and `profile_roles` remain the portal identity and role architecture.

### Role catalog changes

The following role types were added to `portal_role_types`:

- `client_services_director`
- `ceo`
- `payroll_team`

Existing compatibility roles were preserved:

- `admin` remains a compatibility alias for `client_services_director`.
- `payroll` remains a compatibility alias for `payroll_team`.
- `listing_agent` remains active.
- `car_concierge` remains active.
- `vfp_agent` remains unchanged.

### Production role assignments

- Brie Delos Reyes receives the active `client_services_director` role.
- Brie retains the active `admin` compatibility role.
- Jay Grosman receives the active `ceo` role.
- Jay retains the active `listing_agent` role.
- Jay's prior `admin` role assignment is deactivated.
- Legacy `profiles.role` values remain unchanged for frontend compatibility.

### Authoritative role model

Active rows in `profile_roles` are authoritative.

The legacy `profiles.role` field is used only when a profile has no active stored role assignments.

Compatibility mapping is supported between:

- `admin` and `client_services_director`
- `payroll` and `payroll_team`

### Access model

#### Client Services Director

Can manage:

- Profiles
- Portal roles
- Role catalog
- Assignment types
- Listing Agents
- Assignments
- Appointments
- Showing details
- Closing details
- Additional costs
- Notification delivery

Can view:

- All assignments
- Assignment events
- Internal notes
- Deletion audit
- All payroll records

Can generate, submit, review, approve, reject, and hold payroll through authorized functions.

#### CEO

Can view:

- All assignments
- Assignment details
- Assignment events
- Internal notes
- Deletion audit
- All payroll records

Can review, approve, reject, and hold payroll through authorized functions.

The CEO does not receive routine direct assignment-management authority.

#### Payroll Team

Can view:

- Payable assignments
- Approved costs
- Payroll periods
- Payroll runs
- Payroll items
- Payroll line items
- Payroll events
- Required Car Concierge profile information

Can generate, recalculate, and submit payroll through authorized functions.

Cannot directly update assignments, approve costs, approve payroll, or modify payroll projection tables.

#### Listing Agent

Can:

- View assignments linked to their active Listing Agent record.
- Create their own draft Showing.
- Update their own unsent or declined-reassignment Showing.
- Manage appointments and Showing details for their own draft Showing.
- View related operational details and events.

Cannot view unrelated assignments or payroll.

#### Car Concierge

Can:

- View their own released assignments.
- View their own appointments and assignment details.
- View their own completion records.
- View their own costs.
- Submit pending cost requests for their own active assignments.
- View their own payroll records.
- View relevant assignment events.

Cannot view another contractor's assignments or payroll.

### Security behavior

- Anonymous table access is revoked.
- Authenticated privileges are reset to the exact privileges required.
- RLS remains enabled on all controlled portal tables.
- Existing overlapping policies are replaced in one transaction.
- Payroll projection tables remain read-only to ordinary authenticated users.
- Payroll writes remain controlled by Query 32 functions.
- Assignment and payroll event tables remain append-only.
- Deletion-audit records remain read-only.
- `assignment_pay_summary` uses invoker security and obeys underlying RLS.

### Verification required

- Confirm the migration returns success.
- Confirm Brie has active `client_services_director` and `admin` roles.
- Confirm Jay has active `ceo` and `listing_agent` roles.
- Confirm Jay's `admin` assignment is inactive.
- Confirm Brie can still load and use the administrative portal.
- Confirm Jay can view all assignments but cannot directly update routine assignments.
- Confirm Jay can view payroll.
- Confirm Car Concierges see only their own assignments.
- Confirm Car Concierges see only their own payroll.
- Confirm Listing Agents see only linked assignments.
- Confirm Listing Agents can manage only their own draft Showings.
- Confirm Payroll Team access after a Payroll Team user is assigned.
- Confirm anonymous access is denied.
- Confirm assignment acceptance, decline, start, completion, costs, and calendar workflows still function.
- Confirm Query 32 payroll functions still function.

### Deployment note

Keep Query 33 marked `Planned` until the corrected migration runs successfully.

After successful execution:

1. Change Query 33 to `Applied`.
2. Record the execution date and operator.
3. Run the Query 33 verification tests.
4. Change Query 33 to `Verified` only after every role boundary passes.


## Query 34 — User Archiving and Commission Eligibility

**Date:** 2026-07-18  
**Status:** Verified  
**Operator:** Brie Delos Reyes

### Summary

Added an audit-safe portal user lifecycle and separated commission eligibility from portal roles.

The existing `listing_agent` database role remains unchanged for compatibility, but its visible role name is now **Sell Smart Agent**.

Jay Grosman retains the `ceo` and `listing_agent` roles for CEO oversight and Sell Smart operational access. He is explicitly ineligible for commissions across all supported commission programs.

### Database Changes

- Added archive fields to `profiles`:
  - `archived_at`
  - `archived_by_profile_id`
  - `archive_reason`
- Added `portal_user_lifecycle_events`.
- Added `profile_commission_eligibility`.
- Added program-specific commission eligibility for:
  - Vehicle Finder
  - Vehicle Protection Plan
  - Sell Smart
  - Cash Buyer
- Added `portal_profile_is_commission_eligible(...)`.
- Added `commission_agent_category_for_program(...)`.
- Replaced legacy commission-trigger dependency on `profiles.role = 'sales_agent'`.
- Added automatic exclusion for commission-ineligible recipients.
- Added commission company-summary, recipient-summary, and detailed-reporting views.
- Added CEO read access to company-wide commission records.
- Preserved recipient-only access to finalized personal commissions.
- Added `archive_portal_user(...)`.
- Added `restore_portal_user(...)`.
- Added `portal_user_hard_delete_assessment(...)`.
- Added user lifecycle audit history.
- Removed anonymous access from new lifecycle and eligibility resources.
- Preserved all existing commission rules and generated commission formulas.

### Business Rules

- Archiving is the standard method for removing portal access.
- Archived users retain historical assignments, payroll, commissions, and audit records.
- A user with unresolved assignments cannot be archived.
- A Client Services Director cannot archive their own account.
- Permanent deletion is restricted to unused archived accounts with no sign-in or historical references.
- Sell Smart Agent access does not automatically create commission eligibility.
- Jay Grosman does not receive commissions.
- The CEO can view total company commissions and detailed recipient amounts.

### Corrections During Deployment

The initial migration referenced `commission_items.paid_at`, which does not exist. The reporting view was corrected to use `commission_runs.paid_at`.

The failed transaction was automatically rolled back before the corrected migration was rerun.

### Verification

- Static verification: 25 of 25 checks passed.
- Controlled rollback verification: 18 of 18 checks passed.
- Existing commission rules preserved: 8.
- Unexpected commission runs created: 0.
- Unexpected commission items created: 0.
- Temporary role, commission, archive, directory, and lifecycle test records were rolled back.


Query 35 — Open Assignment Pool and Atomic Claiming
Status: Completed and Fully Verified

Implemented:
- Added a sanitized Open Assignment Pool for active Car Concierges.
- Added atomic “Grab Assignment” claiming to prevent double-claims.
- Prevented the original decliner from reclaiming the same assignment.
- Preserved all request, decline, reassignment, claim, and acceptance history.
- Hid client details, exact addresses, notes, calendar details, and hourly rates before claim.
- Added sanitized general-area display for open-pool cards.
- Snapshot the claiming Car Concierge’s current default hourly rate.
- Automatically assigned and accepted the claimed assignment.
- Automatically released and synchronized client-facing and internal calendar events.
- Automatically updated calendar titles to the newly assigned Car Concierge.
- Added scheduler acceptance-confirmation emails.
- Added idempotent notification processing to prevent duplicate emails.
- Updated the portal URL used by the automation to:
  https://portal.iautoagent.com/
- Preserved retry capability for calendar and notification failures without reversing assignment ownership.

Live verification:
- Declined assignment entered the Open Assignment Pool.
- Steve Ellis successfully claimed the assignment.
- Assignment ownership changed to Steve Ellis.
- Open-pool card disappeared immediately after claim.
- Client-facing calendar invite updated to Steve Ellis.
- Internal Car Concierge calendar invite updated to Steve Ellis.
- Scheduler automatically received the acceptance-confirmation email.
- No manual retry actions were required.
- Original decline history remained preserved.
- Original decliner could not reclaim the assignment.

Related corrections:
- Query 35E — Added sanitized general-area display.
- Query 35G — Synced reassigned client-facing calendar titles.
- Query 35I — Added automatic assignment-accepted notifications.
- Query 35J — Backfilled the acceptance notification for the earlier test assignment.

Final result:
Open-pool reassignment now works automatically from decline through claim, calendar synchronization, and scheduler notification.

---

# Version 2 Calendar Synchronization Architecture

## Query 36A — Calendar Synchronization Architecture Foundation

**Status:** Verified  
**Category:** Calendar Automation  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Established the Version 2 calendar synchronization architecture used to separate queue creation from Google Calendar API processing.

### Result

Prepared the portal for:

- Queue-driven synchronization
- Dedicated worker processing
- Retry-safe operations
- Idempotent create, update, and cancel actions
- Independent tracking of calendar synchronization state

---

## Query 36A.2 — Calendar Queue and Registry Foundation

**Status:** Verified  
**Category:** Calendar Automation  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Added the queue and registry foundation required for dedicated calendar synchronization processing.

### Preserved

- Existing assignment ownership
- Existing acceptance workflow
- Existing calendar records
- Existing audit history

---

## Query 36B — Calendar Worker Queue Processing Foundation

**Status:** Verified  
**Category:** Calendar Automation  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Implemented queue claiming and processing support for the dedicated calendar worker.

### Verification

- Queue records could be claimed.
- Successful records were marked complete.
- Failed records retained retry information.
- Empty queue runs completed without errors.

---

## Query 36C.1 — Calendar Create Synchronization

**Status:** Verified  
**Category:** Calendar Automation  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Implemented calendar CREATE processing for assignment invitations.

### Required Email Behavior

```text
sendUpdates=all
```

### Verification

- Client event creation succeeded.
- Car Concierge event creation succeeded.
- Invitations were sent.
- Calendar registry records were persisted.

---

## Query 36C.2 — Calendar Update Synchronization

**Status:** Verified  
**Category:** Calendar Automation  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Implemented calendar UPDATE processing for existing assignment events.

### Required Email Behavior

```text
sendUpdates=none
```

### Verification

- Existing events updated successfully.
- No duplicate events were created.
- Existing event identifiers were preserved.
- Update emails were not resent.

---

## Query 36C.3 — Calendar Cancel Synchronization

**Status:** Verified  
**Category:** Calendar Automation  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Implemented calendar CANCEL processing for assignment events.

### Required Email Behavior

```text
sendUpdates=all
```

### Verification

- Cancellation processing succeeded.
- Recipient cancellation notices were enabled.
- Registry status updates were preserved.
- Processing remained retry-safe.

---

## Query 36C.4 — Calendar Queue Idempotency and Retry Integration

**Status:** Verified  
**Category:** Calendar Automation  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Integrated create, update, and cancel actions with duplicate prevention and safe retry behavior.

### Verification

- Duplicate queue records did not create duplicate calendar events.
- Successful synchronization could be retried safely.
- Queue completion did not reverse assignment ownership.
- Calendar failures remained recoverable.

---

## Query 36D.1 — Calendar Registry Protection

**Status:** Verified  
**Category:** Calendar Security  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Protected calendar registry records from unauthorized or destructive modification.

### Preserved

- Historical calendar identifiers
- Synchronization state
- Assignment association
- Auditability

---

## Query 36D.2 — Calendar Queue Validation and Processing Controls

**Status:** Verified  
**Category:** Calendar Security  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Added queue-processing validation and integrity controls.

### Verification

- Invalid processing states were blocked.
- Completed queue records were not reprocessed improperly.
- Worker execution remained retry-safe.

---

## Query 36D.3 — Portal Role Compatibility Correction

**Status:** Verified  
**Category:** Security  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Corrected the authorization implementation to use:

```sql
portal_actor_has_role(...)
```

### Result

Restored compatibility with the production role model introduced by Query 33.

### Authoritative Version

The corrected `portal_actor_has_role(...)` version is authoritative. The earlier Query 36D.3 draft is superseded.

---

## Query 36D.5 — Calendar Queue Reliability Improvements

**Status:** Verified  
**Category:** Calendar Automation  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Improved queue-processing reliability and consistency.

### Preserved

- Assignment ownership
- Retry history
- Audit history
- Calendar identifiers
- Existing calendar email behavior

---

## Query 36D.6 — Calendar Worker Service Role Permission Support

**Status:** Verified  
**Category:** Permissions  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Granted the trusted Supabase service role the permissions required by the dedicated calendar worker.

### Security Note

Permissions apply only to trusted server-side execution. Anonymous and ordinary authenticated-user access was not expanded.

---

## Query 36D.7 — Calendar Worker Payroll Permission Support

**Status:** Verified  
**Category:** Permissions  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Added payroll-related service-role access required by calendar synchronization processing.

### Result

The synchronization workflow advanced beyond the initial payroll persistence permission boundary.

---

## Query 36D.10 — Calendar Registry Append-Only Audit Compatibility Fix

**Status:** Verified  
**Category:** Calendar Security  
**Applied Date:** 2026-07-22  
**Applied By:** Brie Delos Reyes

### Purpose

Resolved conflicts between calendar-worker processing and append-only calendar audit protections.

### Preserved

- Append-only audit history
- Started-assignment protections
- Existing synchronization history
- Calendar event ownership
- Existing calendar email behavior

### Result

Calendar processing completed without weakening audit safeguards.

---

## Query 36D.11 — Car Concierge Payroll Items Service Role Permission Fix

**Status:** Verified  
**Category:** Permissions  
**Applied Date:** 2026-07-23  
**Applied By:** Brie Delos Reyes

### Purpose

Granted the Supabase `service_role` the access required for:

```text
public.car_concierge_payroll_items
```

### Permissions Granted

- `SELECT`
- `INSERT`
- `UPDATE`

### Error Resolved

```text
permission denied for table car_concierge_payroll_items
```

### Verification

After applying the migration, the assignment synchronization workflow advanced to the next processing stage.

### Security Note

No anonymous or ordinary authenticated-user access was expanded.

---

## Query 36D.12 — Car Concierge Payroll Runs Service Role Permission Fix

**Status:** Verified  
**Category:** Permissions  
**Applied Date:** 2026-07-23  
**Applied By:** Brie Delos Reyes

### Purpose

Granted the Supabase `service_role` the access required for:

```text
public.car_concierge_payroll_runs
```

### Permissions Granted

- `SELECT`
- `INSERT`
- `UPDATE`

### Error Resolved

```text
permission denied for table car_concierge_payroll_runs
```

### Final Verification

The portal returned:

```text
Assignment #12 was updated and the calendar invitations were synchronized.
```

This confirmed:

- `sync-car-concierge-calendar` completed successfully.
- Payroll-item persistence succeeded.
- Payroll-run persistence succeeded.
- Calendar synchronization succeeded.
- No calendar worker modification was required.
- Calendar email behavior remained unchanged.
- Append-only protections remained active.
- Started-assignment protections remained active.

---

# Dedicated Calendar Worker Deployment

**Status:** Verified in Production  
**Date:** 2026-07-22

## Edge Function

```text
calendar-sync-worker
```

A Version 2 worker deployment was verified during production testing.

## Security Configuration

- JWT verification disabled for the worker endpoint.
- `CALENDAR_WORKER_SECRET` configured.
- Requests authenticated using:

```text
x-calendar-worker-secret
```

## Verified Worker Results

A successful worker run returned:

- One queue record claimed
- One queue record succeeded
- Zero failures

A subsequent empty-queue run returned:

- Zero queue records claimed
- Zero failures

## Confirmed Behavior

- Queue processing works.
- Duplicate prevention works.
- Retry behavior works.
- Post-sync persistence works.
- Worker authentication works.
- Empty queue processing works.
- Calendar email behavior remains unchanged.

---

# Current Production Status

The following major portal capabilities are active:

- Assignment lifecycle tracking
- Assignment event history
- Internal assignment notes
- Late-cancellation pay calculation
- Additional-cost approval tracking
- Payroll period generation
- Payroll run calculation and review
- Role-based access control
- User archiving
- Commission eligibility controls
- Open Assignment Pool
- Atomic assignment claiming
- Scheduler acceptance notifications
- Queue-driven Google Calendar synchronization
- Dedicated calendar worker
- Duplicate calendar-event prevention
- Calendar retry support
- Append-only calendar audit protection
- Started-assignment protection
- Portal assignment edit and calendar synchronization

## Current Calendar Email Rules

| Action | Google Calendar Setting |
|---|---|
| CREATE | `sendUpdates=all` |
| UPDATE | `sendUpdates=none` |
| CANCEL | `sendUpdates=all` |

## Current Migration Position

- Latest verified migration: `36D.12`
- Next available migration: `36D.13`
- Existing migration numbers must not be reused or renumbered.
