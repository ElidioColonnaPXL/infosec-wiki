# Kerberos Constrained Delegation

Kerberos delegation lets a front-end service access another service on a user's behalf. Traditional constrained delegation limits the service destinations an account may use; resource-based constrained delegation places the allowlist on the destination. Both models are narrower than unconstrained delegation but still create a meaningful trust path.

## Review

- Inventory accounts and computers configured for every delegation model.
- Validate each allowed service principal against the current application architecture.
- Review who can change `msDS-AllowedToDelegateTo`, `msDS-AllowedToActOnBehalfOfOtherIdentity`, SPNs, and the underlying object ACLs.
- Identify privileged accounts that can be delegated and apply the sensitive-account protection where compatible.
- Remove stale service accounts and delegation entries after application changes.

## Detection and hardening

Monitor delegation-attribute and security-descriptor changes through targeted directory auditing. Baseline Event 4769 activity for delegated services and correlate unusual service-ticket requests with the originating host and account. Use least-privileged service identities, managed secrets, supported encryption, and explicit destination lists. Do not configure traditional constrained delegation and resource-based constrained delegation for the same path without a documented design.

## Reference

- [Microsoft Kerberos delegation guidance](https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/kerberos-authentication-troubleshooting-guidance)
