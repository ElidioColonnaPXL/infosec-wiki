# Kerberos

[Kerberoasting](../../windows-active-directory/notes/kerberoasting.md)
Kerberos Constrained Delegation
Golden Ticket
### **Summary: Kerberos Authentication**

**Kerberos** is the default authentication protocol for domain accounts in Windows since Windows 2000. It is an **open standard** that supports **mutual authentication** — both the user and server verify each other's identity — and operates using **ticket-based authentication**, avoiding transmission of passwords over the network.

#### **Key Components and Process:**

- **Key Distribution Center (KDC):** Located on Domain Controllers, it issues authentication tickets.

- **Ticket Granting Ticket (TGT):** Given after initial login, encrypted using the **krbtgt account**.

- **Ticket Granting Service (TGS):** Issued after presenting a TGT to access specific services; encrypted using the **service’s NTLM password hash**.


#### **Authentication Flow:**

1. **Login:** User sends an encrypted timestamp to the KDC.

2. **TGT Issuance (AS-REQ/AS-REP):** If validated, the KDC issues a TGT.

3. **Service Request (TGS-REQ/TGS-REP):** User uses the TGT to request a TGS for a specific service.

4. **Access (AP-REQ):** TGS is presented to the service. If valid, access is granted.


Kerberos ensures **stateless authentication** and **separates credentials from resource access**, enhancing security. It communicates over **port 88 (TCP/UDP)**, and **Domain Controllers** can be discovered by scanning for this port.

#### **Tools:**

- **Nmap** can be used to find Domain Controllers by identifying open port 88.

Introduction to Active Directory


## Related

- Protocols Index
- Ports and Services
- Network Traffic Analysis

## Detection References

- Kerberoasting and AS-REProasting
- Pass-the-Ticket
- Kerberos brute force
- Golden Ticket anomalies
