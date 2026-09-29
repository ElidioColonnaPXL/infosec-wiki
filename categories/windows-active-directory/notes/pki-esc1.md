# AD CS ESC1

ESC1 is a certificate-template misconfiguration in Active Directory Certificate Services that can allow an enrollee to request a certificate representing another identity. The dangerous combination includes broad enrollment rights, an authentication-capable purpose, requester-controlled subject alternative names, and no effective approval or authorized-signature requirement.

## Review

- Inventory enterprise certification authorities and every published template.
- Identify who can enroll and who can change the template, CA, or publication settings.
- Review subject and SAN controls, issuance requirements, application policies, validity, renewal, and private-key handling.
- Remove templates that are unused or whose business owner is unknown.

## Telemetry

Certification Services auditing can record Event 4886 when a request is received and Event 4887 when a certificate is issued. Correlate requester, template, subject, SAN, source, approval path, and subsequent certificate-based authentication. Monitor template and CA configuration changes separately.

## Mitigation and response

Restrict enrollment, require CA-defined subject information, remove unnecessary authentication EKUs, and use approval or authorized signatures for exceptional issuance paths. If misuse is suspected, disable the affected path, preserve CA records, revoke the certificate, publish current revocation information, investigate the represented identity, and correct both template permissions and object ACLs.

## References

- [Microsoft Certification Services auditing](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/audit-certification-services)
- [SpecterOps Certified Pre-Owned research](https://specterops.io/wp-content/uploads/sites/3/2022/06/Certified_Pre-Owned.pdf)
