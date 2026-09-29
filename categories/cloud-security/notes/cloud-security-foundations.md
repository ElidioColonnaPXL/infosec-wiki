# Cloud Security Foundations

Cloud security combines provider capabilities with customer-controlled identity, configuration, data protection, monitoring, and recovery. The security boundary changes with the service model, but accountability for business data and authorized use never disappears.

## Core control areas

- **Identity:** centralize authentication, require phishing-resistant multi-factor authentication for privileged roles, minimize standing privilege, and review service identities.
- **Configuration:** define approved baselines as code, detect drift, and prevent public or cross-tenant exposure by default.
- **Network:** segment workloads, restrict management paths and egress, and use private service access where it reduces exposure.
- **Data:** classify information, encrypt it in transit and at rest, control keys, and verify deletion and retention behavior.
- **Workloads:** maintain supported images, patch dependencies, protect secrets, and isolate build and deployment systems.
- **Telemetry:** collect control-plane, identity, network, resource, and workload logs into protected central storage.
- **Resilience:** design backups and recovery for account compromise, destructive changes, regional failure, and provider dependency.

## Operating model

Assign an owner to every account, subscription, project, resource, and exception. High-impact changes should use reviewed automation rather than untracked console actions. Continuously inventory exposed services, unused identities, stale keys, permissive trust relationships, and resources outside the approved regions or logging boundary.

A secure design assumes that credentials, a workload, or an administrative session may be compromised. Controls should limit blast radius, preserve evidence, and support recovery without relying on a single cloud account or identity.
