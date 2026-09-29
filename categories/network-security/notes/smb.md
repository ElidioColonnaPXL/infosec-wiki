# SMB


check Windows Fundamentals or Introduction to Active Directory


# SMB (Server Message Block)

## Overview

- **Definition**: A client-server protocol for accessing files, directories, printers, routers, and other network resources across a network.

- **History**: Originated in OS/2 LAN Manager and LAN Server. Adopted widely in Windows.

- **Linux/Unix support**: Implemented via **Samba** (free software project).


### Features

- Allows file/service sharing between devices.

- Uses **TCP (ports 139, 445)** for connections (three-way handshake).

- Provides **shares** independent of local server file structure.

- Access controlled via **ACLs** (Access Control Lists).


---

## SMB Versions

|Version|Supported OS|Features|
|---|---|---|
|CIFS|Windows NT 4.0|NetBIOS communication|
|SMB 1.0|Windows 2000|Direct TCP connection|
|SMB 2.0|Windows Vista / Server 2008|Perf. upgrades, caching, message signing|
|SMB 2.1|Windows 7 / Server 2008 R2|Locking mechanisms|
|SMB 3.0|Windows 8 / Server 2012|Multichannel, encryption, remote storage|
|SMB 3.0.2|Windows 8.1 / Server 2012 R2||
|SMB 3.1.1|Windows 10 / Server 2016|Integrity check, AES-128 encryption|

**Note**: CIFS = SMB1 dialect, considered outdated.

---

## Samba

- Open-source SMB/CIFS implementation for Linux/Unix.

- Provides interoperability with Windows.

- Can act as:

    - File/print server

    - Active Directory member (v3)

    - Active Directory Domain Controller (v4)


### Key Daemons

- `smbd` – file and printer sharing.

- `nmbd` – NetBIOS name resolution, browsing.


---

## Samba Configuration Example (`/etc/samba/smb.conf`)

- **Global settings** apply to all shares.

- **Individual shares** can override global settings.


### Common Directives

- `workgroup` = defines workgroup/domain.

- `path` = directory to share.

- `browseable` = show share in listings.

- `guest ok` = allow unauthenticated access.

- `read only` / `writable` = file access control.

- `create mask`, `directory mask` = permissions for new files/folders.


### Dangerous Settings (for pentesters/red team)

- `browseable = yes` – exposes share listings.

- `guest ok = yes` – anonymous access.

- `read only = no` / `writable = yes` – write access.

- `create mask = 0777`, `directory mask = 0777` – full permissions.


---

## Enumeration & Tools

### Manual

- `smbclient -N -L //<ip>` → list shares (null session).

- `smbstatus` → list active connections.

- `rpcclient` → interact with MS-RPC for enumeration (users, shares, domains).


### Nmap

- Ports: `139`, `445`.

- Scripts:

    - `smb-enum-shares`

    - `smb-enum-users`

    - `smb-os-discovery`


### Impacket samrdump(Python tools)

- **GitHub**: [https://github.com/fortra/impacket](https://github.com/fortra/impacket)

- **Use cases**: SMB, MSRPC, Kerberos exploitation.

- Example: `samrdump.py <ip>` → enumerate users/groups.


### SMBMap

- **GitHub**: [https://github.com/ShawnDEvans/smbmap](https://github.com/ShawnDEvans/smbmap)

- **Use cases**: List/enumerate shares, permissions, download/upload files.

- Example: `smbmap -H <ip>`


### CrackMapExec

- **GitHub**: [https://github.com/byt3bl33d3r/CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec)

- **Use cases**: SMB/WinRM/LDAP enumeration, authentication spraying, exploitation.

- Example: `cme smb <ip> --shares -u '' -p ''`


### Enum4linux-ng

- **GitHub**: [https://github.com/cddmp/enum4linux-ng](https://github.com/cddmp/enum4linux-ng)

- **Use cases**: Automated SMB enumeration (shares, users, groups, OS info).

- Example: `./enum4linux-ng.py <ip> -A`


---

## Attack Vectors & Risks

- **Null sessions** → anonymous enumeration of shares and users.

- **Weak permissions** → guest access, writable shares, full ACLs.

- **RID cycling** → brute force RIDs with `rpcclient` or `impacket` to enumerate users.

- **Credential reuse** → captured hashes/cracked passwords reused across SMB shares.


---

## Key Commands Reference

```bash
# smbclient (list shares anonymously)
smbclient -N -L //<target_ip>

# connect to share
smbclient //<target_ip>/<share>

# download file
smb: \> get file.txt

# rpcclient (null session)
rpcclient -U "" <ip>

# Impacket - samrdump
samrdump.py <ip>

# smbmap
smbmap -H <ip>

# CrackMapExec
cme smb <ip> --shares -u '' -p ''

# Enum4linux-ng
./enum4linux-ng.py <ip> -A
```


## Related

- Protocols Index
- Ports and Services
- Network Traffic Analysis

## Detection References

- PSExec lateral-movement detection
- SMB ransomware detection
