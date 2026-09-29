# Group Policy Permissions and Files

A Group Policy Object has two connected parts: an Active Directory object that stores metadata and permissions, and files in SYSVOL that contain policy content. Security review must cover both locations because an unexpected change to either can alter configuration across many systems.

## Baseline

- Record the owner, delegated editors, links, filtering, version information, and expected SYSVOL files.
- Separate policy authorship from approval for high-impact GPOs.
- Restrict write access to dedicated administrative roles and managed hosts.
- Review inherited permissions, nested groups, backup operators, and automation identities.
- Hash or otherwise baseline critical scripts and policy files with a controlled update process.

## Monitoring

Event 5136 can identify directory-object changes when Directory Service Changes auditing and appropriate SACLs are configured. File-share telemetry such as Event 5145 can add context for SYSVOL access. Correlate changes with GPO version changes, replication, process execution on management hosts, and an approved change record.

## Response

Preserve both AD metadata and SYSVOL content, stop further unauthorized edits, identify affected links and systems, and restore a reviewed version through the normal management path. Revoke unintended permissions and investigate configuration that applied during the exposure window. A honeypot policy is not a substitute for broad integrity monitoring and safe recovery.
