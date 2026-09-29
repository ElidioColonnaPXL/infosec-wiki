# AS-REP Roasting

AS-REP roasting is a Kerberos exposure that exists when an account is configured not to require pre-authentication. The Key Distribution Center can return authentication material encrypted with a key derived from that account's secret, creating an opportunity for offline password guessing.

## Risk conditions

- The `DONT_REQ_PREAUTH` account flag is enabled.
- The account uses a human-managed or otherwise guessable secret.
- The account has privileges or access that make compromise consequential.

## Detection and review

Inventory every account that does not require Kerberos pre-authentication and confirm a documented exception owner. On domain controllers, Event 4768 records ticket-granting-ticket requests; a pre-authentication type of `0` deserves review when it involves an exposed account. Baseline legitimate request sources and correlate unusual activity with account changes and sign-ins.

## Mitigation and response

Restore pre-authentication unless a tested compatibility requirement prevents it. Use long, randomly generated service-account secrets or a managed service account, apply least privilege, and monitor configuration drift. If suspicious requests coincide with an account exposure, disable or contain the account as appropriate, rotate its secret, invalidate active sessions, and review its access for follow-on activity.

## Reference

- [Microsoft Event 4768 reference](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4768)
