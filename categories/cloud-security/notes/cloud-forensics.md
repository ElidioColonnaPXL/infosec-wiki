# Cloud Forensics

Cloud forensics preserves and analyzes evidence from provider control planes, identity systems, managed services, virtual workloads, and customer applications. Collection must respect legal authority, tenant boundaries, provider retention, and the risk that ordinary remediation changes evidence.

## Evidence sources

- Identity sign-ins, token activity, role assignments, and access-policy decisions.
- Administrative and control-plane operations against resources.
- Resource configuration, tags, policy results, and deployment history.
- Network flow, firewall, DNS, load-balancer, proxy, and service-access logs.
- Workload disks, snapshots, memory where supported, endpoint telemetry, and application logs.
- Object versions, database audit data, key-management events, and backup history.

## Collection workflow

1. Confirm authority, affected tenants, time range, time zones, and retention limits.
2. Preserve identity and control-plane logs before short retention windows expire.
3. Isolate affected resources through a documented management path that retains evidence.
4. Capture configuration and metadata before creating snapshots or copies.
5. Export to a restricted evidence location using immutable retention where available.
6. Hash exported artifacts, record provider identifiers and timestamps, and maintain chain of custody.
7. Validate completeness by comparing independent identity, network, resource, and workload sources.

Cloud snapshots are not automatically complete forensic images: consistency, volatile state, encryption keys, managed-service internals, and provider metadata may require separate handling. Keep original exports read-only, analyze copies, and document every transformation and provider-side action.
