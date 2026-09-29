# IPv6

`IPv6` is a protocol with many new features, which also has many other advantages over IPv4:

- Larger address space
- Address self-configuration (SLAAC)
- Multiple IPv6 addresses per interface
- Faster routing
- End-to-end encryption (IPsec)
- Data packages up to 4 GByte

|**Features**|**IPv4**|**IPv6**|
|---|---|---|
|Bit length|32-bit|128 bit|
|OSI layer|Network Layer|Network Layer|
|Adressing range|~ 4.3 billion|~ 340 undecillion|
|Representation|Binary|Hexadecimal|
|Prefix notation|192.0.2.10/24|fe80::dd80:b1a9:6687:2d3b/64|
|Dynamic addressing|DHCP|SLAAC / DHCPv6|
|IPsec|Optional|Mandatory|

There are four different types of IPv6 addresses:

|**Type**|**Description**|
|---|---|
|`Unicast`|Addresses for a single interface.|
|`Anycast`|Addresses for multiple interfaces, where only one of them receives the packet.|
|`Multicast`|Addresses for multiple interfaces, where all receive the same packet.|
|`Broadcast`|Do not exist and is realized with multicast addresses.|

Let's look at an example with an IPv4, at how the IPv4 address (`192.168.12.160`) would look in hexadecimal representation.

|**Representation**|**1st Octet**|**2nd Octet**|**3rd Octet**|**4th Octet**|
|---|---|---|---|---|
|Binary|1100 0000|1010 1000|0000 1100|1010 0000|
|`Hex`|`C0`|`A8`|`0C`|`A0`|
|Decimal|192|168|12|160|

An IPv6 address can look like this:

- Full IPv6: `fe80:0000:0000:0000:dd80:b1a9:6687:2d3b/64`
- Short IPv6: `fe80::dd80:b1a9:6687:2d3b/64`

An IPv6 address consists of two parts:

- `Network Prefix` (network part)
- `Interface Identifier` also called `Suffix` (host part)

The `Network Prefix` identifies the network, subnet, or address range. The `Interface Identifier` is formed from the `48-bit MAC` address (which we will discuss later) of the interface and is converted to a `64-bit address` in the process. The default prefix length is `/64`. However, other typical prefixes are `/32`, `/48`, and `/56`. If we want to use our networks, we get a shorter prefix (e.g. `/56`) than `/64` from our provider.

In RFC 5952, the aforementioned IPv6 address notation was defined:

- All alphabetical characters are always written in lower case.
- All leading zeros of a block are always omitted.
- One or more consecutive blocks of `4 zeros` (hex) are shortened by two colons (`::`).
- The shortening to two colons (`::`) may only be performed `once` starting from the left.


## Related

- Protocols Index
- Ports and Services
- Network Traffic Analysis
