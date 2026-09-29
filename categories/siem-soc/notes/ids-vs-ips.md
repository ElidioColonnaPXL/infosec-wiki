# IDS vs IPS

Like the firewall, the intrusion detection system (`IDS`) and intrusion prevention system (`IPS`) are also software-based components. `IDS` scans the network for potential attacks, analyzes them, and reports any detected attacks. `IPS` complements `IDS` by taking specific defensive measures if a potential attack should have been detected. The analysis of such attacks is based on pattern matching and signatures. If specific patterns are detected, such as a service detection scan, `IPS` may prevent the pending connection attempts.


#### 1. Network-Based IDS/IPS (NIDS/NIPS)

|**Description**|
|---|
|Hardware device or software solution placed at strategic points in the network to inspect all passing traffic.|
|`Example`: A sensor connected to the core switch that monitors traffic within a data center.|

#### 2. Host-Based IDS/IPS (HIDS/HIPS)

|**Description**|
|---|
|Runs on individual hosts or devices, monitoring inbound/outbound traffic and system logs for suspicious behavior on that specific machine.|
|`Example`: An antivirus or endpoint security agent installed on a server.|

IDS/IPS can be placed at several strategic locations in a network. One option is to position them behind the firewall, where the firewall filters obvious threats, and the IDS/IPS inspects any remaining traffic. Another common placement is in the DMZ (Demilitarized Zone), a separate network segment within the larger network directly exposed to the internet, where they monitor traffic moving in and out of publicly accessible servers. Finally, IDS/IPS solutions can also run directly on endpoint devices, such as servers or workstations, to detect suspicious activity at the host level. The following diagram shows an IDS/IPS positioned after the firewall.
