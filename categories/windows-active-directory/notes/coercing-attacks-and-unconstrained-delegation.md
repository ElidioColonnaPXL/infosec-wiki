# Authentication Coercion and Unconstrained Delegation

Authentication coercion abuses a reachable service or RPC interface to make a Windows system authenticate to another endpoint. The authentication becomes dangerous when it can be relayed to an insufficiently protected service or when a privileged identity reaches a host trusted for unconstrained delegation.

## Risk conditions

- Domain controllers or other high-value servers can initiate unnecessary outbound SMB or related authentication.
- NTLM remains broadly enabled and target services do not enforce relay-resistant protections.
- SMB signing or protocol-specific Extended Protection for Authentication is absent where supported.
- Non-domain-controller systems use unconstrained delegation.
- Privileged accounts are permitted to be delegated.

## Prevention

Restrict outbound SMB from domain controllers and management tiers to documented destinations, require SMB signing, enable Extended Protection on supported services, and reduce NTLM after auditing dependencies. Remove unconstrained delegation where possible and mark sensitive administrative identities as non-delegable. Limit RPC exposure with supported firewall and service controls.

## Detection and response

Monitor unexpected outbound authentication from servers, RPC activity followed by SMB or HTTP authentication, NTLM use, firewall denies, delegation changes, and ticket activity on delegation hosts. If coercion is suspected, isolate the involved endpoints, preserve authentication and firewall telemetry, remove the relay or delegation path, rotate exposed identities, and review the privileges used after the event.

## References

- [Microsoft SMB interception defenses](https://learn.microsoft.com/en-us/windows-server/storage/file-server/smb-interception-defense)
- [Microsoft Active Directory account delegation guidance](https://learn.microsoft.com/windows/security/identity-protection/access-control/active-directory-accounts)
