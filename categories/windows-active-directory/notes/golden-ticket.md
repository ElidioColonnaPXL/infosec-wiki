# Golden Ticket Risk

A Golden Ticket is a forged Kerberos ticket-granting ticket created with compromised `krbtgt` key material. Because domain controllers use that material to protect TGTs, exposure can enable durable impersonation that is not resolved by changing an ordinary administrator password.

## Defensive signals

Look for ticket properties that conflict with normal policy, unexpected account or group combinations, unusual lifetimes, authentication from unmanaged sources, and service access that lacks the expected preceding activity. Correlate domain-controller Kerberos events with endpoint sign-ins, directory changes, and network telemetry; no single field reliably proves forgery.

## Prevention

Protect domain controllers and backups, restrict replication rights, use dedicated privileged workstations, separate administrative tiers, and monitor access to `krbtgt` material. Maintain healthy replication and a rehearsed domain-compromise recovery plan.

## Response

Treat suspected `krbtgt` compromise as a domain incident. Contain affected hosts and identities, preserve evidence, validate domain-controller and replication health, and identify persistence before rotating keys. Microsoft guidance uses two carefully planned `krbtgt` password resets separated by at least the effective ticket lifetime; rushing this action can disrupt authentication or leave older key material valid. Rotate other exposed privileged and service credentials as part of the broader recovery plan.

## Reference

- [Microsoft krbtgt reset guidance](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/forest-recovery-guide/ad-forest-recovery-reset-the-krbtgt-password)
