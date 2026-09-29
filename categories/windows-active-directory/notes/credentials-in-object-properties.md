# Secrets in Active Directory Object Properties

Active Directory attributes are replicated and may be readable by far more principals than the object owner expects. Descriptions, notes, custom attributes, script paths, and deployment metadata must not be used as secret storage.

## Review

- Search appropriate text-bearing attributes for secret patterns without exporting unnecessary personal data.
- Review who can read and modify sensitive object classes and attributes.
- Identify automation that writes deployment values into directory objects.
- Establish an approved vault for service secrets, recovery material, and API tokens.

Directory Service Changes auditing can produce Event 5136 when a monitored object is modified. Use targeted SACLs on high-value objects, because broad auditing can be noisy. Correlate changes with the actor, management host, approved change, and subsequent authentication activity.

## Remediation

Removing the text does not neutralize an exposed secret. Rotate or revoke it first, update every dependent service through controlled change, remove the directory value, and review backups, replication history, logs, and systems that may have consumed it. Restrict write permissions and add preventive secret scanning to provisioning workflows.

## Reference

- [Microsoft Audit Directory Service Changes](https://learn.microsoft.com/windows/security/threat-protection/auditing/audit-directory-service-changes)
