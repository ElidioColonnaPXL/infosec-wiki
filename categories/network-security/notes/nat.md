# Network Address Translation (NAT)
#### What is NAT?

`Network Address Translation (NAT)` is a process carried out by a router or a similar device that modifies the source or destination IP address in the headers of IP packets as they pass through. This modification is used to translate the private IP addresses of devices within a local network to a single public IP address that is assigned to the router.

#### How NAT Works

Consider a home network with several devices, such as a laptop, a smartphone, and a gaming console, each assigned a unique private IP address: the laptop at 192.168.1.10, the smartphone at 192.168.1.11, and the gaming console at 192.168.1.12. The home router managing this network has two critical interfaces. The LAN (Local Area Network) interface connects to the private network with an IP address of 192.168.1.1, while the WAN (Wide Area Network) interface, connected to the ISP’s network, carries a public IP address, 203.0.113.50.

The process of NAT translation begins when a device, say the laptop, sends a request to visit a website like [www.google.com](http://www.google.com/). This request packet, originating with the private IP of 192.168.1.10, is sent to the router. Here, the NAT function of the router modifies the source IP in the packet header from the private IP to the public IP of the router, 203.0.113.50. This packet then travels across the internet to reach the intended web server. Upon receiving the packet, the web server sends a response back to the router's public IP. As the response arrives, the router's NAT table, which keeps track of IP mappings, identifies that 203.0.113.50:4444 corresponds to the laptop at 192.168.1.10:5555 (ports 4444 and 5555 are dynamic). The router then translates the public IP back to the laptop’s private IP and forwards the internal response to the laptop, completing the communication cycle.


#### Types of NAT

It's important to know that there are several types of Network Address Translation (NAT), each designed for specific networking needs. Below are the different types of NAT.

|**Type**|**Description**|
|---|---|
|`Static NAT`|Involves a one-to-one mapping, where each private IP address corresponds directly to a public IP address.|
|`Dynamic NAT`|Assigns a public IP from a pool of available addresses to a private IP as needed, based on network demand.|
|`Port Address Translation (PAT)`|Also known as NAT Overload, is the most common form of NAT in home networks. Multiple private IP addresses share a single public IP address, differentiating connections by using unique port numbers. This method is widely used in home and small office networks, allowing multiple devices to share a single public IP address for internet access.|

#### Benefits and Trade-Offs

Network Address Translation (NAT) offers a number of benefits and presents some trade-offs as well.

|**Benefits**|
|---|
|Conserves the limited IPv4 address space.|
|Provides a basic layer of security by not exposing internal network structure directly.|
|Flexible for internal IP addressing schemes.|

|**Trade-Offs**|
|---|
|Complex services like hosting a public server behind NAT can require additional configuration (e.g., port forwarding).|
|NAT can break certain protocols that rely on end-to-end connectivity without special handling.|
|Adds complexity to troubleshooting connectivity issues.|


## Related

- Protocols Index
- Ports and Services
- Network Traffic Analysis
