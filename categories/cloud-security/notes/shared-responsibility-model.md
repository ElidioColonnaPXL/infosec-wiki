# Shared Responsibility Model

The shared responsibility model separates controls operated by a cloud provider from controls operated by the customer. Exact boundaries depend on the service and contract, so the provider's current service documentation is authoritative.

| Control area | IaaS | PaaS | SaaS |
|---|---|---|---|
| Physical facilities and hardware | Provider | Provider | Provider |
| Hypervisor and managed platform | Provider | Provider | Provider |
| Guest operating system | Customer | Usually provider | Provider |
| Application code and dependencies | Customer | Customer | Usually provider |
| Tenant configuration and access | Customer | Customer | Customer |
| Identities, endpoints, and data use | Shared/customer-led | Shared/customer-led | Shared/customer-led |
| Logging, retention, and response integration | Shared | Shared | Shared |

## Questions for each service

1. Which layers can the customer configure, patch, inspect, export, or restore?
2. Which security features are enabled by default, optional, or tied to a higher service tier?
3. Who owns encryption keys, backups, identity recovery, and log retention?
4. What evidence can the provider supply during an incident, and for how long?
5. Which subcontractors, regions, and external dependencies handle the data?

“Provider managed” does not mean “customer unaccountable.” Customers still decide who receives access, what data enters the service, how tenant settings are governed, which logs leave the platform, and how the organization responds when an identity or workload is compromised.
