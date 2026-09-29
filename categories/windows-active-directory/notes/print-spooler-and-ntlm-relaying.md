# Print Spooler and NTLM Relay Risk

The Windows Print Spooler exposes remote procedure calls for printer management and notifications. On systems that do not need printing, especially domain controllers, an enabled remote spooler increases attack surface and can participate in authentication-coercion chains. The impact depends on where authentication can travel and whether the receiving service accepts relayed credentials.

## Hardening

- Disable the Print Spooler on domain controllers and other servers that do not print.
- Where printing is required, restrict remote client connections and RPC reachability.
- Require SMB signing and use Extended Protection for Authentication on supported services.
- Restrict outbound SMB and HTTP authentication from high-value systems.
- Audit and reduce NTLM dependencies, preferring Kerberos where practical.
- Keep Windows and print components supported and patched.

## Detection

Inventory spooler state on high-value systems and alert on unexpected service enablement or configuration changes. Correlate spooler RPC activity with outbound SMB or HTTP authentication, NTLM events, firewall telemetry, and access from unusual sources. A blocked connection can be useful context but should be interpreted against normal print-management traffic.

## Response

Contain the initiating and receiving systems, preserve RPC, authentication, process, and network evidence, and determine whether relay produced a successful privileged session. Disable the unnecessary service or remote access path, enforce the missing relay protection, and rotate any identity shown to have been exposed.

## References

- [Microsoft Print Spooler service guidance](https://learn.microsoft.com/en-us/troubleshoot/windows-server/printing/print-spooler-service-not-running)
- [Microsoft SMB signing overview](https://learn.microsoft.com/windows-server/storage/file-server/smb-signing-overview)
