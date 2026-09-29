# Kerberoasting

Kerberoasting targets service accounts with Service Principal Names. A domain user can legitimately request a service ticket, and part of that ticket is protected with key material tied to the service account. Weak account secrets can therefore be tested offline without repeated authentication attempts.

## Risk conditions

- A user-managed service account has an SPN and a weak or long-lived secret.
- The account retains excessive privileges or interactive sign-in rights.
- Legacy encryption remains available where stronger Kerberos encryption is supported.

## Detection

Event 4769 on domain controllers records service-ticket requests, including the requesting account, target service, source address, and encryption information. Alerting should use an environment baseline: unusual request volume, rare service targets, unexpected sources, or legacy encryption are investigation signals, not standalone proof of abuse.

## Hardening

- Prefer group Managed Service Accounts where applications support them.
- Use unique, long, randomly generated secrets and rotate them safely.
- Remove unnecessary SPNs, privileges, group membership, and sign-in rights.
- Inventory encryption support before phasing out legacy types.
- Monitor SPN, delegation, and service-account permission changes.

## Reference

- [Microsoft Event 4769 reference](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4769)
