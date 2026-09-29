# Security Testing Scoping Process

A scope converts a security-testing objective into explicit authorization, technical boundaries, safety controls, and deliverables. Work should not begin until the owner and testing team share the same written interpretation.

## Scope record

| Area | Questions to resolve |
|---|---|
| Objectives | What decisions should the work support, and what is out of scope? |
| Assets | Which domains, address ranges, applications, APIs, cloud accounts, facilities, or identities are included? |
| Authorization | Who owns each asset, and who can approve changes or emergency actions? |
| Techniques | Which activities are allowed, restricted, or prohibited? |
| Timing | What are the testing windows, blackout periods, and time zone? |
| Safety | What rate limits, data limits, and stop conditions apply? |
| Communication | Who receives start notices, urgent findings, daily status, and escalation calls? |
| Evidence | How will data be encrypted, transferred, retained, and destroyed? |
| Deliverables | What report format, severity model, validation evidence, and retest are expected? |

## Change control

Resolve hostnames and cloud identifiers before work begins, but treat discoveries as unapproved until the owner adds them to scope. Record every change with approver, time, rationale, and affected assets. If ownership or authorization is uncertain, pause that activity and escalate through the agreed contact path.

A rules-of-engagement document should also define incident handling, third-party infrastructure, social engineering, denial-of-service risk, persistence, cleanup, and the conditions that end the work.
