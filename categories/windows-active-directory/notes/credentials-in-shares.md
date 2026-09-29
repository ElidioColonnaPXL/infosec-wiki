# Secrets in Network Shares

Shared folders often accumulate deployment scripts, exported configuration, unattended setup files, backups, and administrator notes. A share can be correctly authenticated yet still expose sensitive material because its file permissions, inheritance, or group membership are too broad.

## Review

- Inventory shares, owners, business purpose, and effective access.
- Inspect high-risk file types and recent additions with an approved secret scanner.
- Include hidden, administrative, archived, and application deployment locations.
- Validate both share permissions and NTFS permissions; the effective result depends on both.
- Monitor changes to privileged group membership that expands access indirectly.

Detailed File Share auditing can record Event 5145 for checked access when the relevant policy and SACLs are configured. Combine file telemetry with sign-in, process, and network data rather than alerting on a filename alone.

## Remediation

Revoke or rotate exposed secrets, preserve evidence needed for the investigation, remove the sensitive copy, and search for duplicates and downstream use. Apply least privilege, designate an accountable data owner, set retention rules, and move operational secrets into a managed vault. Do not rely on obscured filenames or hidden shares as access control.
