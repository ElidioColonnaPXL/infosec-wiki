# DCSync

DCSync describes abuse of Active Directory replication permissions to request password-related directory data through replication interfaces. The requester does not need to run on a domain controller if its account holds the relevant replication rights, so an accidental delegation can turn an ordinary identity into a domain-wide credential risk.

## Prevention

- Limit directory replication rights to domain controllers and explicitly approved services.
- Review `Replicating Directory Changes`, `Replicating Directory Changes All`, and filtered-set rights on each domain root.
- Protect accounts that can alter ACLs or group membership around those rights.
- Separate privileged administration from routine work and monitor delegation drift.

## Detection

With suitable directory-service auditing and SACLs, Event 4662 can help identify replication-related access. Enrich it with the requesting principal, source host, network RPC activity, directory changes, and whether the source is an expected domain controller. A single event is not sufficient without environment context.

## Response

Revoke unauthorized rights, contain the requesting identity and host, preserve replication and sign-in evidence, and determine which credential material may have been exposed. Rotate affected accounts in an order that respects service dependencies. If domain compromise is plausible, use the organization's tested recovery plan for privileged identities, domain controllers, and the `krbtgt` account.

## Reference

- [Microsoft Event 4662 reference](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4662)
