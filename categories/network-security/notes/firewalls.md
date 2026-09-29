# Firewalls

A firewall is a security measure against unauthorized connection attempts from external networks. Every firewall security system is based on a software component that monitors network traffic between the firewall and incoming data connections and decides how to handle the connection based on the rules that have been set. It checks whether individual network packets are being passed, ignored, or blocked. This mechanism is designed to prevent unwanted connections that could be potentially dangerous.

---
#### 1. Packet Filtering Firewall

|**Description**|
|---|
|Operates at Layer 3 (Network) and Layer 4 (Transport) of the OSI model.|
|Examines source/destination IP, source/destination port, and protocol type.|
|`Example`: A simple router ACL that only allows HTTP (port 80) and HTTPS (port 443) while blocking other ports.|

#### 2. Stateful Inspection Firewall

|**Description**|
|---|
|Tracks the state of network connections.|
|More intelligent than packet filters because they understand the entire conversation.|
|`Example`: Only allows inbound data that matches an already established outbound request.|

#### 3. Application Layer Firewall (Proxy Firewall)

|**Description**|
|---|
|Operates up to Layer 7 (Application) of the OSI model.|
|Can inspect the actual content of traffic (e.g., HTTP requests) and block malicious requests.|
|`Example`: A web proxy that filters out malicious HTTP requests containing suspicious patterns.|

#### 4. Next-Generation Firewall (NGFW)

|**Description**|
|---|
|Combines stateful inspection with advanced features like deep packet inspection, intrusion detection/prevention, and application control.|
|`Example`: A modern firewall that can block known malicious IP addresses, inspect encrypted traffic for threats, and enforce application-specific policies.|

Firewalls stand between the internet and the internal network, examining traffic before letting it through. In a home environment, our router/modem often has a built-in firewall (software-based). In that case, it’s all in one device, and the firewall function is `inside` the router. In larger networks (e.g., business environments), the firewall is often a separate device placed after the modem/router and before the internal network, ensuring all traffic must pass through it.
