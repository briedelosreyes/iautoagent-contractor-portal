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
| 29 | Inspect Steve Assignment Calendar Sync | Inspection | Not required | — | — |
| 30 | Assignment Lifecycle and Payroll Foundation | Schema | Planned | — | — |
| 31 | Assignment Timeline and Internal Notes | Schema | Planned | — | — |
| 32 | Payroll Batches and Approval Workflow | Schema | Planned | — | — |
| 33 | Role Model and Access Policies | Security | Planned | — | — |
| 34 | Cancellation and Late-Pay Engine | Functions | Planned | — | — |
| 35 | Completion and Cost Notification Tracking | Schema | Planned | — | — |
| 36 | Assignment Deletion Audit | Schema | Planned | — | — |
| 37 | Payroll Notification Outbox Events | Automation | Planned | — | — |

---

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
- Query 30 is the next schema migration.
- Inspection queries remain documented even when they do not modify the database.
- Do not mark planned queries as applied until they have been successfully run in Supabase.
