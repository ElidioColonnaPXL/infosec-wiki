


# ARP Poisoning – PCAP Analysis

## Analysis Information

| Field | Value |
|------|------|
| Attack Type | ARP Spoofing / Poisoning |
| PCAP File | ARP_Spoof.pcapng |
| Tools Used | Wireshark, tcpdump |
| Protocol Focus | ARP |
| Objective | Detect abnormal ARP behavior and identify attacker |

---

# Overview

In this analysis, we investigate an **ARP poisoning attack** using a provided PCAP file.  
ARP is frequently abused because it lacks authentication, making it vulnerable to **man-in-the-middle (MITM)** and **denial-of-service (DoS)** attacks.

ARP traffic is broadcast-based, which makes anomalies easier to detect during packet analysis.

---

# How ARP Works (Normal Behavior)

Before detecting anomalies, we need to understand normal ARP behavior.

## Process

1. Host A wants to communicate with Host B.
2. Host A checks its **ARP cache**.
3. If unknown → sends broadcast:
   
   Who has x.x.x.x?

4. Host B replies with its MAC address.
5. Host A stores the mapping in its ARP cache.

---

# Attack Explanation – ARP Poisoning

## Scenario

- Victim machine
- Router (gateway)
- Attacker machine

## Attack Flow

1. Attacker sends fake ARP replies to victim and router.
2. Victim thinks attacker = router.
3. Router thinks attacker = victim.
4. Traffic is redirected to attacker.
5. Attacker can:
   - drop traffic (DoS)
   - forward traffic (MITM)
   - modify traffic

---

# Packet Analysis

## Step 1 – Open PCAP

```

wireshark ARP_Spoof.pcapng

```

## Step 2 – Filter ARP Traffic

```

arp.opcode

```

- arp.opcode == 1 → Requests  
- arp.opcode == 2 → Replies  

---

## Step 3 – Detect Suspicious Behavior

### Indicator 1 – Excessive ARP Traffic

```

arp.opcode == 1

```

Look for:
- repeated broadcasts
- duplicate requests

---

### Indicator 2 – Duplicate IP Detection

```

arp.duplicate-address-detected && arp.opcode == 2

```

This indicates:
- one IP mapped to multiple MAC addresses

---

## Step 4 – Identify Suspicious MAC

Example:

```

08:00:27:53:0c:ba

```

---

## Step 5 – Validate with ARP Table

```

arp -a | grep 50:eb:f6:ec:0e:7f
arp -a | grep 08:00:27:53:0c:ba

```

Example result:

```

192.168.10.4 → 50:eb:f6:ec:0e:7f
192.168.10.4 → 08:00:27:53:0c:ba

```

This confirms ARP poisoning.

---

## Step 6 – Identify Original IP

```

(arp.opcode) && ((eth.src == 08:00:27:53:0c:ba) || (eth.dst == 08:00:27:53:0c:ba))

```

Observation:

- MAC 08:00:27:53:0c:ba was originally:
  
  192.168.10.5

- Now impersonating:
  
  192.168.10.4

---

## Step 7 – Traffic Analysis

```

eth.addr == 50:eb:f6:ec:0e:7f or eth.addr == 08:00:27:53:0c:ba

```

Look for:

- dropped TCP → DoS
- mirrored traffic → MITM

---

# Indicators of Compromise (IOCs)

- Duplicate IP detection
- Multiple MAC addresses for one IP
- Excessive ARP replies
- MAC ↔ IP changes
- Broadcast anomalies

---

# Mitigation

- Static ARP entries
- Port security (switch)
- Dynamic ARP Inspection (DAI)
- Network monitoring

---

# Summary

This PCAP shows a classic **ARP poisoning attack**:

- Attacker spoofed victim IP
- ARP cache poisoned
- Duplicate mappings detected
- Traffic disruption observed

---


