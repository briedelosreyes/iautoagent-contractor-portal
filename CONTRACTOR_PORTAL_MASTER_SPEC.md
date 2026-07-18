# iAutoAgent Contractor Portal — Master Specification

**Document name:** `CONTRACTOR_PORTAL_MASTER_SPEC.md`  
**System:** iAutoAgent Contractor Portal  
**Version:** 1.0  
**Status:** Approved for implementation  
**Primary repository:** GitHub Pages repository for the Contractor Portal  
**Primary database:** Supabase  
**Primary integrations:** Google Calendar, email notifications, Supabase Edge Functions

---

# 1. Purpose

This document is the authoritative functional and technical specification for the iAutoAgent Contractor Portal.

It defines:

- User roles
- Permissions
- Assignment lifecycle
- Calendar behavior
- Notification rules
- Cancellation rules
- Additional-cost approval
- Payroll generation and approval
- ACH payout tracking
- Audit and timeline requirements
- Dashboard requirements
- Security requirements
- Version 1 implementation boundaries

When this document conflicts with an older chat, draft, or informal note, this document should be treated as the current approved source unless it is formally updated.

---

# 2. System Objectives

The Contractor Portal must allow iAutoAgent to:

1. Create and manage Car Concierge assignments.
2. Assign work to Car Concierges and Listing Agents.
3. Schedule and synchronize assignment appointments with Google Calendar.
4. Allow Car Concierges to accept, decline, and complete assignments.
5. Allow Car Concierges to submit additional-cost requests.
6. Allow the Client Services Director to approve or deny additional costs.
7. Calculate projected contractor pay by semimonthly pay period.
8. Apply the approved late-cancellation pay rule.
9. Allow the Payroll Team to generate projected payouts.
10. Require Client Services Director approval before ACH payout initiation.
11. Track ACH payout initiation and payment completion.
12. Provide executive visibility through a separate CEO role.
13. Preserve a complete audit trail of important system activity.
14. Prevent users from accessing or modifying data outside their authority.

---

# 3. Approved Version 1 Roles

The portal will support five distinct roles:

1. CEO
2. Client Services Director
3. Payroll Team
4. Listing Agent
5. Car Concierge

A user may have one or more roles only when specifically authorized. Permissions must be evaluated from the authenticated user's stored role assignments, not from interface visibility alone.

---

# 4. Role Definitions and Permissions

## 4.1 CEO

The CEO role is intended for Jay and must remain separate from the Client Services Director role.

### CEO can

- View all assignments
- View all Car Concierges
- View all Listing Agents
- View all payroll periods
- View all contractor payout records
- View projected, approved, initiated, and paid payout amounts
- View assignment timelines
- View payroll timelines
- View deletion audit records
- View cancellations
- View additional-cost requests
- View completion records
- View operational reports
- View executive dashboards
- Add executive or internal notes
- Place a payroll record on hold
- Approve or reject payroll projections when authorized
- Reopen a payroll record when a correction is required
- Perform an emergency assignment cancellation

### CEO should not be responsible for routine operations

The CEO dashboard should not default to:

- Routine assignment creation
- Routine assignment editing
- Calendar setup
- Additional-cost processing
- Completion processing
- ACH initiation
- Permanent deletion of assignments

Emergency override permissions may exist, but routine operational controls should remain outside the primary CEO interface.

---

## 4.2 Client Services Director

The Client Services Director is the primary operational administrator.

### Client Services Director can

- Create assignments
- Edit assignments
- Assign or reassign a Car Concierge
- Assign or update a Listing Agent
- View all assignments
- Search all assignments
- Filter assignments by status
- Cancel assignments
- Permanently delete mistaken assignments
- Review additional-cost requests
- Approve additional costs
- Partially approve additional costs
- Deny additional costs
- Cancel additional-cost requests when appropriate
- Review payroll projections
- Approve payroll projections
- Reject payroll projections
- Place payroll projections on hold
- Add approval notes
- View all payroll records
- View all audit records
- View all assignment timelines
- View all internal notes
- View reporting and dashboards

### Client Services Director restrictions

The Client Services Director should not:

- Record ACH initiation unless separately granted Payroll Team access
- Mark ACH payouts paid unless separately granted Payroll Team access
- Change system-calculated payroll amounts silently

Any payroll adjustment must be recorded as a separate adjustment with a reason and audit trail.

---

## 4.3 Payroll Team

The Payroll Team role is responsible for payroll preparation and ACH payout tracking.

### Payroll Team can

- View contractor payroll data
- View payable assignments
- View approved additional costs
- View late-cancellation pay
- View contractor totals by pay period
- Generate projected contractor payouts
- Save payroll projections as draft
- Submit payroll projections for approval
- Revise rejected payroll projections
- Resubmit corrected payroll projections
- Record ACH payout initiation
- Add an ACH confirmation or reference number
- Add payout notes
- Mark a payout paid
- View payroll history
- Export payroll data when implemented

### Payroll Team cannot

- Create or edit assignments
- Change assignment hours
- Change assignment rates
- Change cancellation eligibility
- Approve additional costs
- Approve its own payroll projection
- Cancel assignments
- Delete assignments
- Approve payroll projections
- Alter completed assignment data without an authorized correction process

### ACH-only rule

The company uses ACH for contractor payouts.

Therefore:

- The system must not ask the Payroll Team to select a payout method.
- No payout-method field is required for normal Version 1 use.
- Any stored payment method should default to ACH internally only if needed for technical compatibility.

---

## 4.4 Listing Agent

### Listing Agent can

- View assignments linked to that Listing Agent
- View showings personally booked by that Listing Agent
- Receive relevant Google Calendar invitations
- Receive completion notifications
- Cancel a showing personally booked by that Listing Agent
- Enter a cancellation reason for that showing
- View relevant assignment timeline events

### Listing Agent cannot

- View unrelated assignments
- Cancel a showing booked by another Listing Agent
- Cancel the entire assignment unless separately authorized
- Delete assignments
- Edit Car Concierge pay
- Approve additional costs
- Generate payroll
- Approve payroll
- Record ACH initiation

### Listing Agent cancellation rule

A Listing Agent may cancel only a showing that:

1. Is linked to that Listing Agent, and
2. Was personally booked by that Listing Agent.

This restriction must be enforced server-side.

---

## 4.5 Car Concierge

### Car Concierge can

- View their own assignments
- Accept an assignment
- Decline an assignment
- View assignment details
- View appointment details
- Complete an assignment
- Submit additional-cost requests
- Upload or enter required completion information
- View projected pay
- View completed assignments
- View approved additional costs
- View late-cancellation pay
- Filter pay by payroll period
- View payout status
- View relevant timeline events

### Car Concierge cannot

- View other contractors' assignments
- Cancel assignments
- Delete assignments
- Approve costs
- Generate payroll
- Approve payroll
- Record ACH initiation
- Mark payouts paid
- Change system-calculated rates or hours

---

# 5. Assignment Types

Version 1 supports the existing assignment types already used in the portal, including:

- Photos and Videos
- Showings
- Closings
- Pickups
- Drop-offs
- Other approved Car Concierge assignment types

Each assignment type may have type-specific fields, but all assignments must follow the common lifecycle and audit rules in this document.

---

# 6. Assignment Lifecycle

## 6.1 Approved assignment statuses

The primary assignment statuses are:

- Pending
- Active
- Completed
- Canceled

Deletion is not an ordinary assignment status. Deleted assignments are removed from operational views and preserved through a separate deletion audit record.

## 6.2 Status definitions

### Pending

The assignment has been created but has not yet become active.

Examples:

- Waiting for contractor response
- Waiting for required appointment information
- Waiting for release or assignment

### Active

The assignment is accepted or otherwise in progress.

### Completed

The Car Concierge has submitted required completion information and the system has accepted the completion.

### Canceled

The assignment will not proceed but remains preserved for history, reporting, and possible late-cancellation pay.

---

# 7. Assignment Creation

The Client Services Director creates assignments.

At minimum, the system should support:

- Assignment type
- Vehicle or case reference
- Client information
- Car Concierge
- Listing Agent, when applicable
- Appointment date and time
- Pickup date and time when applicable
- Drop-off date and time when applicable
- Location
- Assignment rate or pay basis
- Instructions
- Internal notes
- Client-facing notes when applicable

The system must validate all fields required by the selected assignment type before creation.

Upon successful creation, the system must:

1. Create the assignment record.
2. Create applicable appointment records.
3. Record an `Assignment Created` timeline event.
4. Queue required calendar events.
5. Queue required notifications.
6. Record calendar and email processing outcomes.

---

# 8. Assignment Acceptance and Decline

## 8.1 Acceptance

A Car Concierge may accept only an assignment offered to that Car Concierge.

On acceptance:

- Status should become Active when appropriate.
- Acceptance timestamp must be stored.
- Accepting user must be stored.
- `Assignment Accepted` must be recorded in the timeline.
- Relevant operational notifications may be sent.
- Duplicate acceptance must be prevented.

## 8.2 Decline

A Car Concierge may decline only an assignment offered to that Car Concierge.

On decline:

- Decline timestamp must be stored.
- Decline reason should be captured.
- `Assignment Declined` must be recorded.
- Client Services Director should be notified.
- The assignment remains available for reassignment.
- The system must not delete the assignment.

---

# 9. Google Calendar Requirements

## 9.1 Invite recipients

Calendar invitations should include the appropriate participants based on assignment type:

- Client Services Director
- Assigned Car Concierge
- Listing Agent when applicable
- Client when applicable and approved
- Other explicitly authorized participants

## 9.2 Listing Agent requirement

For Photos and Videos and other relevant assignments:

- Listing Agent must be stored on the assignment.
- Listing Agent must be copied on the applicable Google Calendar invitation.

## 9.3 Calendar event tracking

The database must store enough information to support:

- Google Calendar event ID
- Calendar sync status
- Last sync attempt
- Successful sync timestamp
- Error details
- Retry count
- Cancellation status

## 9.4 Calendar cancellation

When an assignment or eligible showing is canceled:

- Related Google Calendar events must be canceled.
- Cancellation must be idempotent.
- Failure must be logged.
- Retry must be supported.
- The assignment cancellation should not be blocked permanently by a temporary calendar failure.

---

# 10. Completion Workflow

A Car Concierge completes an assignment through the portal.

Required completion data depends on assignment type and may include:

- Completion date and time
- Hours worked
- Mileage when applicable
- Photos
- Videos
- Documents
- Notes
- Exceptions
- Additional-cost requests
- Confirmation that assignment instructions were completed

Upon successful completion:

1. Assignment status becomes Completed.
2. Completion timestamp is stored.
3. Completing user is stored.
4. Payable assignment amount is finalized according to approved rules.
5. `Assignment Completed` is recorded in the timeline.
6. Client Services Director receives a completion email.
7. Listing Agent receives a completion email when applicable.
8. Notification delivery is logged.
9. Duplicate completion emails are prevented.

---

# 11. Completion Email Rules

When any assignment is completed:

## Required recipients

- Client Services Director
- Listing Agent when the assignment has an applicable Listing Agent

## Email content

The email should include:

- Assignment number
- Assignment type
- Vehicle or case reference
- Car Concierge
- Completion date and time
- Completion notes
- Link to the assignment
- Relevant completion attachments or links when supported

## Duplicate protection

The system must store:

- Notification type
- Assignment ID
- Recipient
- Queued timestamp
- Sent timestamp
- Delivery status
- Error details
- Retry count

The same completion email must not be sent twice to the same recipient unless an authorized manual resend occurs.

---

# 12. Additional-Cost Requests

## 12.1 Submission

A Car Concierge may submit an additional-cost request related to their own assignment.

Required fields:

- Assignment ID
- Requested amount
- Cost category
- Description
- Receipt or evidence when applicable
- Submission timestamp
- Submitted by

## 12.2 Immediate notification

When submitted:

- Client Services Director receives an email immediately.
- `Additional Cost Submitted` is recorded in the timeline.
- The request status becomes Pending.

## 12.3 Approved statuses

Additional-cost request statuses are:

- Pending
- Approved
- Denied
- Canceled

## 12.4 Review fields

The system must support:

- Requested amount
- Approved amount
- Reviewed by
- Reviewer role
- Reviewed timestamp
- Approval notes
- Denial reason
- Cancellation reason

## 12.5 Payroll rule

Only the approved amount counts toward projected pay.

Pending, denied, or canceled amounts must not count toward projected pay.

Partial approval is allowed when the approved amount is lower than the requested amount.

---

# 13. Cancellation Rules

## 13.1 Cancel versus Delete

Cancellation and deletion are fundamentally different.

### Cancel

Use cancellation when the assignment was validly created but will no longer proceed.

Cancellation:

- Preserves assignment history
- Preserves assignment number
- Preserves audit records
- Cancels calendar events
- Sends notifications
- May create late-cancellation pay
- Remains visible in canceled and all-assignment views

### Delete

Use deletion only when the assignment should never have existed.

Examples:

- Test record
- Duplicate
- Wrong client
- Accidental creation
- Other clear data-entry mistake

Deletion:

- Removes the assignment from operational views
- Must not create cancellation pay
- Requires an audit record
- Requires Client Services Director authority
- Requires explicit confirmation

---

# 14. Assignment Cancellation Authority

## Client Services Director

May cancel any assignment for a legitimate business reason.

## CEO

May cancel an assignment as an executive or emergency override.

## Listing Agent

May cancel only a showing personally booked by that Listing Agent.

## Car Concierge

May not cancel assignments.

## Payroll Team

May not cancel assignments.

---

# 15. Cancellation Data Requirements

A cancellation must record:

- Assignment ID
- Assignment number
- Cancellation timestamp
- Canceled by user ID
- Canceled by name
- Canceled by role
- Cancellation reason
- Cancellation notes
- Scheduled pickup timestamp snapshot
- Minutes before pickup
- Late-cancellation eligibility
- Cancellation-pay hours
- Cancellation-pay amount
- Calendar cancellation status
- Notification status

---

# 16. Late-Cancellation Pay Rule

Assignments that may create cancellation pay always have a scheduled pickup appointment.

The rule is based only on the scheduled pickup time.

## Payable cancellation

If the assignment is canceled less than 60 minutes before the scheduled pickup time:

- The Car Concierge receives one hour of pay.
- The payment is classified as `Late Cancellation Pay`.
- The payment remains visible in payroll and projected pay.

## Non-payable cancellation

If the assignment is canceled exactly 60 minutes before pickup or earlier:

- Cancellation pay is $0.
- The canceled assignment must not appear as payable projected compensation.

## Calculation requirements

The system must:

- Use authoritative database timestamps.
- Store the pickup time used in the calculation.
- Store the cancellation time used in the calculation.
- Store the calculated minute difference.
- Prevent the result from changing if the appointment is later edited.
- Record `Late Cancellation Pay Applied` when pay is created.
- Record a non-payable cancellation event when no pay is created.

---

# 17. Deletion Workflow

Only the Client Services Director may permanently delete a mistaken assignment in Version 1.

Before deletion, the user must:

1. Select a deletion reason.
2. Enter deletion notes.
3. Type `DELETE` exactly to confirm.

The deletion process must:

- Capture a complete audit snapshot.
- Cancel calendar events where applicable.
- Prevent cancellation pay.
- Remove dependent records safely.
- Preserve the deletion audit even after the operational assignment record is removed.

## Deletion audit fields

- Assignment number
- Assignment type
- Vehicle or case reference
- Client
- Car Concierge
- Listing Agent
- Previous status
- Appointment details
- Deleted by
- Deleter role
- Deleted timestamp
- Deletion reason
- Deletion notes
- Calendar cleanup result
- Selected assignment snapshot data

---

# 18. Assignment Timeline

Every important assignment event must be recorded in a timeline.

## Required event types

- Assignment Created
- Assignment Assigned
- Assignment Reassigned
- Calendar Sent
- Calendar Sync Failed
- Assignment Accepted
- Assignment Declined
- Additional Cost Submitted
- Additional Cost Approved
- Additional Cost Partially Approved
- Additional Cost Denied
- Assignment Completed
- Completion Email Sent
- Completion Email Failed
- Assignment Canceled
- Calendar Canceled
- Late Cancellation Pay Applied
- Internal Note Added
- Payroll Included
- Payroll Approved
- Payout Initiated
- Paid

## Timeline fields

- Event ID
- Assignment ID
- Event type
- Event timestamp
- Actor user ID
- Actor name
- Actor role
- Previous status or value
- New status or value
- Amount when applicable
- Notes
- Structured metadata
- Source, such as portal, Edge Function, system, or administrator

Timeline entries must be append-only for ordinary users.

---

# 19. Internal Notes

The portal must use timestamped internal notes rather than relying only on one editable notes field.

Each internal note should store:

- Assignment ID or payroll record ID
- Note text
- Created by
- Creator role
- Created timestamp
- Edited timestamp when editing is permitted
- Visibility classification when needed

Internal notes should appear chronologically and should not silently overwrite earlier notes.

---

# 20. Payroll Periods

The standard payroll schedule is semimonthly.

## First pay period

- Begins on the 1st
- Ends on the 15th

## Second pay period

- Begins on the 16th
- Ends on the final calendar day of the month

## Inclusion dates

Unless later changed by written policy:

- Completed assignment pay is included based on completion date.
- Late-cancellation pay is included based on cancellation date.
- Approved additional costs are included based on approval date.

---

# 21. Car Concierge Payroll View

The Car Concierge portal must offer these filters:

- Current pay period
- Previous pay period
- 1st through 15th
- 16th through end of month
- Custom date range

The view must show:

- Projected Pay
- Completed assignment pay
- Approved additional costs
- Late Cancellation Pay
- Adjustments when applicable
- Total projected amount
- Payment status
- Pay period
- Payout history

Use the terms:

- `Projected Pay`
- `Expected Contractor Payment`

Do not use the word `Commission` for Car Concierge compensation.

Non-payable cancellations must not be included in projected pay.

---

# 22. Payroll Data Structure

The recommended payroll model includes:

## payroll_batches

Represents one payroll processing cycle.

Suggested fields:

- Batch ID
- Pay-period start
- Pay-period end
- Batch status
- Created by
- Created timestamp
- Submitted timestamp
- Approved timestamp
- Completed timestamp
- Notes

## contractor_payouts

Represents one contractor's payout within a payroll batch.

Suggested fields:

- Payout ID
- Batch ID
- Contractor ID
- Projected assignment pay
- Approved additional costs
- Late-cancellation pay
- Adjustments
- Projected total
- Approved total
- Payout status
- Generated by
- Generated timestamp
- Submitted timestamp
- Approved by
- Approved role
- Approved timestamp
- Approval notes
- Rejection notes
- Hold notes
- ACH initiated timestamp
- ACH initiated by
- ACH reference
- ACH notes
- Paid timestamp
- Marked paid by

## contractor_payout_items

Represents individual payable items included in a payout.

Possible item types:

- Completed Assignment
- Approved Additional Cost
- Late Cancellation Pay
- Authorized Adjustment

Each item must retain its source record and amount.

---

# 23. Payroll Statuses

Approved Version 1 payroll statuses:

- Draft
- Pending Client Services Approval
- Approved for Payout
- Rejected
- On Hold
- ACH Payout Initiated
- Paid
- Reopened

## Status rules

### Draft

Payroll Team is preparing the projection.

### Pending Client Services Approval

Projection has been submitted and is waiting for review.

### Approved for Payout

Client Services Director or authorized CEO approved the projection.

### Rejected

Projection requires correction before resubmission.

### On Hold

Processing is paused pending clarification or resolution.

### ACH Payout Initiated

Payroll Team has initiated the ACH payout.

### Paid

Payroll Team has confirmed the payout as paid.

### Reopened

A previously approved, initiated, or paid record has been reopened through an authorized correction process.

---

# 24. Payroll Generation Workflow

## Step 1: Payroll Team generates projected amount

The Payroll Team selects a pay period and generates one projected payout per contractor.

The calculation includes:

- Completed assignment pay
- Approved additional costs
- Late-cancellation pay
- Authorized adjustments

The system records:

- Generated by
- Generated timestamp
- Original projected amount
- Included payout items

## Step 2: Payroll Team reviews draft

Payroll Team may review the itemized projection before submission.

## Step 3: Payroll Team submits for approval

Upon submission:

- Status becomes `Pending Client Services Approval`.
- Submitted timestamp is recorded.
- Submitting Payroll Team user is recorded.
- Client Services Director receives an email.
- `Submitted for Approval` is added to the payroll timeline.

---

# 25. Payroll Approval Workflow

## Client Services Director review options

The Client Services Director may:

- Approve
- Reject
- Place on hold
- Add review notes

An authorized CEO may perform the same actions when needed.

## Approval rule

The approver should not silently overwrite the submitted projected amount.

If a change is necessary:

- The original amount remains visible.
- The difference must be entered as an adjustment.
- A reason is required.
- The action is audited.

## On approval

The system must:

- Set status to `Approved for Payout`.
- Record approved amount.
- Record approver.
- Record approver role.
- Record approval timestamp.
- Record approval notes.
- Email the Payroll Team member who submitted the projection.
- Record `Payroll Approved`.

## On rejection

The system must:

- Set status to `Rejected`.
- Require rejection notes.
- Email the Payroll Team member who submitted the projection.
- Allow revision and resubmission.
- Record `Payroll Rejected`.

## On hold

The system must:

- Set status to `On Hold`.
- Require hold notes.
- Email the Payroll Team member who submitted the projection.
- Record `Payroll Placed on Hold`.

---

# 26. Payroll Notification Rules

## Projection submitted

Recipient:

- Client Services Director

Email should include:

- Contractor
- Pay period
- Projected amount
- Completed assignment total
- Approved additional-cost total
- Late-cancellation total
- Adjustments
- Payroll Team submitter
- Link to review

## Projection approved

Recipient:

- The Payroll Team member who submitted the projection

Email should include:

- Contractor
- Pay period
- Approved amount
- Approved by
- Approver role
- Approval timestamp
- Approval notes
- Link to payout record

## Projection rejected

Recipient:

- The Payroll Team member who submitted the projection

Email should include:

- Contractor
- Pay period
- Rejection reason
- Rejected by
- Required correction
- Link to revise

## Projection placed on hold

Recipient:

- The Payroll Team member who submitted the projection

Email should include:

- Contractor
- Pay period
- Hold reason
- Placed on hold by
- Required follow-up
- Link to record

## Projection revised and resubmitted

Recipient:

- Client Services Director

The resubmission email must identify the revision and prior rejection or hold status.

---

# 27. ACH Payout Workflow

Once a payout is approved:

1. Payroll Team initiates ACH through the company's external ACH process.
2. Payroll Team records the initiation in the portal.
3. Status becomes `ACH Payout Initiated`.
4. Payroll Team later confirms payment completion.
5. Status becomes `Paid`.

## ACH initiation fields

Required:

- ACH amount initiated
- ACH initiation date
- Initiated by

Optional:

- ACH confirmation or reference number
- Notes

Automatically stored:

- Initiated timestamp
- Previous status
- New status

## Paid fields

Required:

- Paid date
- Marked paid by

Optional:

- Final ACH reference
- Notes

---

# 28. Payroll Timeline

Required payroll timeline events:

- Projection Generated
- Projection Submitted
- Projection Approved
- Projection Rejected
- Projection Placed on Hold
- Projection Revised
- Projection Resubmitted
- ACH Payout Initiated
- Payout Marked Paid
- Payroll Reopened
- Adjustment Added
- Adjustment Removed

Each event must include:

- User
- Role
- Timestamp
- Previous status
- New status
- Amount when applicable
- Notes
- Supporting metadata

---

# 29. Dashboard Requirements

## 29.1 CEO Dashboard

The CEO dashboard should prioritize:

- Active assignments
- Pending operational issues
- Payroll awaiting approval
- Payouts on hold
- ACH payouts initiated
- Paid contractor totals
- Late-cancellation totals
- Additional-cost trends
- Assignment completion metrics
- Contractor utilization
- Operational alerts
- High-level reports

The CEO dashboard should emphasize visibility and oversight rather than routine data entry.

## 29.2 Client Services Director Dashboard

The Client Services Director dashboard should prioritize:

- Create assignment
- Pending assignments
- Active assignments
- Completed assignments
- Canceled assignments
- Additional costs awaiting review
- Payroll awaiting approval
- Calendar errors
- Notification errors
- Search and filters
- Assignment timeline
- Delete mistaken assignment workflow

## 29.3 Payroll Team Dashboard

The Payroll Team dashboard should prioritize:

- Current payroll period
- Draft payroll batches
- Projections ready to submit
- Rejected projections
- Payouts on hold
- Approved payouts
- ACH payouts to initiate
- Initiated payouts awaiting completion
- Paid history
- Contractor-level itemization
- Export controls

## 29.4 Listing Agent Dashboard

The Listing Agent dashboard should prioritize:

- My assignments
- My showings
- Upcoming calendar appointments
- Completed assignments
- Cancel eligible showing
- Relevant timeline events

## 29.5 Car Concierge Dashboard

The Car Concierge dashboard should prioritize:

- Offered assignments
- Active assignments
- Upcoming appointments
- Complete assignment
- Submit additional cost
- Projected Pay
- Pay-period filters
- Payout status
- Relevant timeline

---

# 30. Search and Filtering

## Client Services Director filters

- Pending
- Active
- Completed
- Canceled
- All

Search should support:

- Assignment number
- Vehicle
- Case number
- Client
- Listing Agent
- Car Concierge
- Date
- Assignment type
- Status

## Payroll filters

- Current pay period
- Previous pay period
- Contractor
- Payroll status
- Date range
- Batch
- Approved by
- Initiated by
- Paid status

---

# 31. Notification Architecture

Notifications should be processed through a database-backed outbox pattern.

Each queued notification should store:

- Notification ID
- Notification type
- Related record type
- Related record ID
- Recipient
- Subject
- Template data
- Status
- Attempt count
- Queued timestamp
- Last attempt timestamp
- Sent timestamp
- Error details
- Unique deduplication key

## Notification statuses

- Pending
- Processing
- Sent
- Failed
- Canceled

## Duplicate prevention

A unique deduplication key should prevent repeated automatic sends for the same event and recipient.

Manual resend, when later implemented, must create a new authorized resend record.

---

# 32. Edge Function Requirements

Supabase Edge Functions will be responsible for trusted server-side actions such as:

- Google Calendar creation
- Google Calendar cancellation
- Email delivery
- Payroll notification processing
- Cancellation calculations
- Permission-sensitive actions
- Timeline creation where database triggers are not appropriate
- Retry handling
- Service-role database access

## Security requirements

- Service-role keys must never be exposed in browser code.
- Browser code must never determine final authorization.
- Server-side functions must verify the authenticated user.
- Server-side functions must validate the user's role.
- Server-side functions must validate ownership and scope.
- Privileged actions must be idempotent where practical.

---

# 33. Row-Level Security Requirements

Supabase Row-Level Security must enforce data access.

## CEO

May read executive and operational records according to approved scope.

## Client Services Director

May read and manage operational records according to approved scope.

## Payroll Team

May read payroll source data and manage payroll records but must not modify assignments or approvals outside payroll authority.

## Listing Agent

May read only linked assignments and showings.

## Car Concierge

May read only assignments and payroll records belonging to that Car Concierge.

RLS policies must not rely solely on an email address when a stable user ID is available.

---

# 34. Data Integrity Requirements

The database must enforce:

- Valid status values
- Valid role values
- Nonnegative monetary values
- Required timestamps
- Required approver information
- Required cancellation reasons
- Required deletion reasons
- One active payout per contractor per payroll batch unless explicitly allowed
- No duplicate automatic notification event for the same recipient
- No unauthorized cross-contractor payroll access
- No late-cancellation pay without a scheduled pickup timestamp
- No payout initiation before approval
- No paid status before ACH initiation unless an authorized exception is recorded

---

# 35. Time Zone Rules

The business operates using Central Time for operational interpretation.

The database should store timestamps in UTC.

The interface should display operational dates and times in the configured business time zone.

Cancellation calculations must be performed from absolute timestamps, not from formatted display strings.

Daylight Saving Time must be handled through a named time zone, such as:

`America/Chicago`

Do not calculate Central Time by applying a permanent fixed UTC offset.

---

# 36. Audit Requirements

The system must preserve an audit trail for:

- Role changes
- Assignment creation
- Assignment edits
- Assignment reassignment
- Assignment acceptance
- Assignment decline
- Assignment cancellation
- Assignment deletion
- Cost requests
- Cost decisions
- Completion
- Payroll generation
- Payroll submission
- Payroll decisions
- ACH initiation
- Paid status
- Record reopening
- Manual adjustments
- Notification failures
- Calendar failures

Audit records should be append-only for ordinary portal users.

---

# 37. Version 1 Reports

Version 1 reporting should support:

- Assignment count by status
- Assignment count by type
- Assignment count by Car Concierge
- Completion rate
- Decline rate
- Cancellation rate
- Late-cancellation pay totals
- Additional-cost request totals
- Approved additional-cost totals
- Projected payroll totals
- Approved payroll totals
- ACH initiated totals
- Paid totals
- Payroll records awaiting approval
- Payroll records on hold

Revenue reporting is not required unless the necessary business data is already available and approved for the portal.

---

# 38. Version 1 Implementation Milestones

## Milestone 1: Database Foundation

- Assignment lifecycle fields
- Cancellation fields
- Cost approval fields
- Timeline tables
- Internal notes
- Payroll tables
- Deletion audit
- Notification tracking
- Roles and policies

## Milestone 2: Backend Logic

- Cancellation engine
- Late-cancellation pay engine
- Timeline writer
- Email notifications
- Calendar updates
- Payroll calculations
- Permission enforcement

## Milestone 3: Client Services Director Portal

- Assignment filters
- Search
- Cancellation workflow
- Delete workflow
- Cost review
- Payroll approval
- Timeline
- Internal notes

## Milestone 4: Listing Agent Portal

- My assignments
- My showings
- Calendar view
- Eligible showing cancellation
- Timeline

## Milestone 5: Car Concierge Portal

- Assignment workflow
- Completion
- Additional-cost submission
- Projected Pay
- Pay-period filters
- Payout history

## Milestone 6: Payroll Portal

- Payroll generation
- Payroll itemization
- Approval submission
- Rejected projection revision
- ACH initiation
- Paid status
- Payroll history
- Export

## Milestone 7: CEO Dashboard

- Executive metrics
- Payroll visibility
- Operational alerts
- Authorized approval and hold actions
- Reports

---

# 39. Planned SQL Migration Sequence

The Database Change Log remains the authoritative migration register.

The approved upcoming sequence is:

- Query 30 — Assignment Lifecycle and Payroll Foundation
- Query 31 — Assignment Timeline and Internal Notes
- Query 32 — Payroll Batches and Approval Workflow
- Query 33 — Role Model and Access Policies
- Query 34 — Cancellation and Late-Pay Engine
- Query 35 — Completion and Cost Notification Tracking
- Query 36 — Assignment Deletion Audit
- Query 37 — Payroll Notification Outbox Events

Do not reuse or renumber these queries after execution begins.

---

# 40. Deferred Version 2 Items

The following may be considered later but are not required for Version 1 unless separately approved:

- Automated ACH provider integration
- Contractor tax-document management
- Advanced payroll exports
- Contractor dispute workflow
- Mobile application
- SMS notifications
- Push notifications
- Advanced analytics
- Revenue and margin reporting
- Multi-company or multi-branch support
- Automated rate rules by geography
- Contractor availability scheduling
- In-app chat
- Client-facing portal
- Automated receipt extraction
- Formal correction and dispute approval workflow
- Multi-level payroll approval

---

# 41. Acceptance Criteria

Version 1 is considered functionally complete only when:

1. Every role sees only authorized data and controls.
2. Client Services Director can create, edit, cancel, and delete eligible assignments.
3. Listing Agents can cancel only personally booked showings.
4. Car Concierges can accept, decline, complete, and submit costs.
5. Completion emails reach required recipients without duplicates.
6. Additional costs require approval before payroll inclusion.
7. Late-cancellation pay follows the strict less-than-60-minute rule.
8. Payroll Team can generate and submit projected payouts.
9. Client Services Director receives the submission email.
10. Submitting Payroll Team member receives the approval decision email.
11. Payroll Team can record ACH initiation.
12. Payroll Team can mark payouts paid.
13. CEO has a separate role and executive dashboard.
14. Assignment and payroll timelines capture required events.
15. Deleted assignments retain a complete deletion audit.
16. Google Calendar creation and cancellation are tracked and retryable.
17. RLS and server-side authorization block unauthorized access.
18. All production database changes are recorded in `DATABASE_CHANGELOG.md`.

---

# 42. Document Maintenance

This specification should be updated whenever an approved business rule changes.

For every material update:

1. Update the version number.
2. Update the status or revision date.
3. Add the decision to the change history below.
4. Create any required new SQL migration rather than editing applied migration history.
5. Update the Database Change Log.

---

# 43. Specification Change History

| Version | Date | Change | Approved By |
|---|---|---|---|
| 1.0 | 2026-07 | Initial master specification based on approved Version 1 requirements | Brie Delos Reyes |

---

# 44. Repository Placement

Store this file in the root of the Contractor Portal GitHub repository.

Recommended root structure:

```text
/
├── index.html
├── CNAME
├── README.md
├── DATABASE_CHANGELOG.md
├── CONTRACTOR_PORTAL_MASTER_SPEC.md
├── docs/
├── sql/
├── supabase/
├── assets/
├── css/
└── js/
```

The master specification and database change log belong in the repository root because they govern the entire project.
