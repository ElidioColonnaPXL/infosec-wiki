# classes

|**`Class`**|**Network Address**|**First Address**|**Last Address**|**Subnetmask**|**CIDR**|**Subnets**|**IPs**|
|---|---|---|---|---|---|---|---|
|`A`|1.0.0.0|1.0.0.1|127.255.255.255|255.0.0.0|/8|127|16,777,214 + 2|
|`B`|128.0.0.0|128.0.0.1|191.255.255.255|255.255.0.0|/16|16,384|65,534 + 2|
|`C`|192.0.0.0|192.0.0.1|223.255.255.255|255.255.255.0|/24|2,097,152|254 + 2|
|`D`|224.0.0.0|224.0.0.1|239.255.255.255|Multicast|Multicast|Multicast|Multicast|
|`E`|240.0.0.0|240.0.0.1|255.255.255.255|reserved|reserved|reserved|reserved|

## Network and Gateway Addresses
|**Class**|**Network Address**|**`First Address`**|**Last Address**|**Subnetmask**|**CIDR**|**Subnets**|**`IPs`**|
|---|---|---|---|---|---|---|---|
|A|1.0.0.0|`1.0.0.1`|126.255.255.255|255.0.0.0|/8|126|16,777,214 `+ 2`|
|B|128.0.0.0|`128.0.0.1`|191.255.255.255|255.255.0.0|/16|16,384|65,534 `+ 2`|
|C|192.0.0.0|`192.0.0.1`|223.255.255.255|255.255.255.0|/24|2,097,152|254 `+ 2`|
|D|224.0.0.0|`224.0.0.1`|239.255.255.255|Multicast|Multicast|Multicast|Multicast|
|E|240.0.0.0|`240.0.0.1`|255.255.255.255|reserved|reserved|reserved|reserved|

## Broadcast Address
|**Class**|**Network Address**|**First Address**|**`Last Address`**|**Subnetmask**|**CIDR**|**Subnets**|**IPs**|
|---|---|---|---|---|---|---|---|
|A|1.0.0.0|1.0.0.1|`127.255.255.255`|255.0.0.0|/8|127|16,777,214 + 2|
|B|128.0.0.0|128.0.0.1|`191.255.255.255`|255.255.0.0|/16|16,384|65,534 + 2|
|C|192.0.0.0|192.0.0.1|`223.255.255.255`|255.255.255.0|/24|2,097,152|254 + 2|
|D|224.0.0.0|224.0.0.1|`239.255.255.255`|Multicast|Multicast|Multicast|Multicast|
|E|240.0.0.0|240.0.0.1|`255.255.255.255`|reserved|reserved|reserved|reserved|

#### 1st Octet - Value: 192

  IP Addresses

```console
Values:         128  64  32  16  8  4  2  1
Binary:           1   1   0   0  0  0  0  0
```

If we calculate the sum of all these values for each octet where the bit is set to `1`, we get the sum:

|**Octet**|**Values**|**Sum**|
|---|---|---|
|1st|128 + 64 + 0 + 0 + 0 + 0 + 0 + 0|= `192`|
|2nd|128 + 0 + 32 + 0 + 8 + 0 + 0 + 0|= `168`|
|3rd|0 + 0 + 0 + 0 + 8 + 0 + 2 + 0|= `10`|
|4th|0 + 0 + 32 + 0 + 0 + 4 + 2 + 1|= `39`|

The entire representation from binary to decimal would look like this:

#### IPv4 - Binary Notation

  IP Addresses

```console
Octet:             1st         2nd         3rd         4th
Binary:         1100 0000 . 1010 1000 . 0000 1010 . 0010 0111
Decimal:           192    .    168    .     10    .     39
```

- IPv4 Address: `192.168.10.39`

This addition takes place for each octet, which results in a decimal representation of the `IPv4 address`. The subnet mask is calculated in the same way.

#### IPv4 - Decimal to Binary

  IP Addresses

```console
Values:         128  64  32  16  8  4  2  1
Binary:           1   1   1   1  1  1  1  1
```

|**Octet**|**Values**|**Sum**|
|---|---|---|
|1st|128 + 64 + 32 + 16 + 8 + 4 + 2 + 1|= `255`|
|2nd|128 + 64 + 32 + 16 + 8 + 4 + 2 + 1|= `255`|
|3rd|128 + 64 + 32 + 16 + 8 + 4 + 2 + 1|= `255`|
|4th|0 + 0 + 0 + 0 + 0 + 0 + 0 + 0|= `0`|

#### Subnet Mask

  IP Addresses

```console
Octet:             1st         2nd         3rd         4th
Binary:         1111 1111 . 1111 1111 . 1111 1111 . 0000 0000
Decimal:           255    .    255    .    255    .     0
```

- IPv4 Address: `192.168.10.39`

- Subnet mask: `255.255.255.0`


## CIDR

`Classless Inter-Domain Routing` (`CIDR`) is a method of representation and replaces the fixed assignment between IPv4 address and network classes (A, B, C, D, E).
Let us stick to the following IPv4 address and subnet mask as an example:

- IPv4 Address: `192.168.10.39`

- Subnet mask: `255.255.255.0`


Now the whole representation of the IPv4 address and the subnet mask would look like this:

- CIDR: `192.168.10.39/24`

The CIDR suffix is, therefore, the sum of all ones in the subnet mask.

  IP Addresses

```console
Octet:             1st         2nd         3rd         4th
Binary:         1111 1111 . 1111 1111 . 1111 1111 . 0000 0000 (/24)
Decimal:           255    .    255    .    255    .     0
```

> **Missing source attachment: `Pasted image 20251126103738.png`:**


## Related

- Protocols Index
- Ports and Services
- Network Traffic Analysis
