# Active Directory Object ACLs

Active Directory objects use security descriptors and access-control entries to decide who may read, modify, own, or delegate control over an object. Rights such as `GenericAll`, `GenericWrite`, `WriteDACL`, `WriteOwner`, and attribute-specific writes can create indirect privilege paths even when the principal is not a member of a privileged group.

## Review

- Compare effective rights with an approved administrative model.
- Include inherited permissions, nested groups, delegated organizational units, and protected objects.
- Map paths between ordinary principals and high-value users, groups, computers, certificate templates, and policies.
- Require an owner and business justification for nonstandard delegations.

Event 5136 can record object changes, while Event 4662 can describe operations on audited directory objects when appropriate SACLs and audit policy are present. Correlate events with change records and known management hosts; either event can be high volume and incomplete without deliberate audit design.

## Hardening and response

Remove unnecessary delegations, separate administrative tiers, protect permission-management roles, and monitor security-descriptor changes. For an unauthorized change, preserve the old and new descriptor, identify the actor and affected objects, restore a reviewed baseline, revoke unintended access, and investigate actions performed while that access existed.
