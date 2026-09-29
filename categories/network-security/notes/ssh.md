# SSH

Linux Fundamentals

# SSH

## Overview

Secure Shell (SSH) enables encrypted and direct communication between two systems over insecure networks. It primarily runs on **TCP port 22** and prevents third-party interception of sensitive data.

- Runs on all common OS (Linux, macOS, Windows via external tools).

- OpenSSH is the widely used open-source implementation.

- Two versions exist:

    - **SSH-1**: Insecure, vulnerable to MITM attacks.

    - **SSH-2**: Secure, faster, and stable (standard today).


---

## Core Uses

- Remote shell access (CLI or GUI).

- Secure file transfers.

- Command execution on remote hosts.

- Port forwarding and tunneling.


---

## Authentication Methods (OpenSSH)

1. Password authentication

2. Public-key authentication

3. Host-based authentication

4. Keyboard-interactive authentication

5. Challenge-response authentication

6. GSSAPI authentication


### Public Key Authentication (most common)

- Server sends its public key → client verifies.

- Client proves authorization with private key + passphrase.

- Keys:

    - **Private key**: stays on client, secured with passphrase.

    - **Public key**: placed on server.

- Benefits: only one passphrase needed per session, stronger security than passwords.


---

## Configuration

Configuration file: **`/etc/ssh/sshd_config`**

### Default Config (example)

```bash
Include /etc/ssh/sshd_config.d/*.conf
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
```

Most options are commented out and require manual hardening.

---

## Dangerous Settings

|Setting|Description|Risk|
|---|---|---|
|`PasswordAuthentication yes`|Allows password auth|Brute-forceable|
|`PermitEmptyPasswords yes`|Allows empty passwords|Immediate compromise|
|`PermitRootLogin yes`|Direct root login|Privilege escalation risk|
|`Protocol 1`|Uses SSH-1|Vulnerable, outdated|
|`X11Forwarding yes`|Enables GUI forwarding|Attack surface expansion|
|`AllowTcpForwarding yes`|Allows TCP tunneling|Lateral movement risk|
|`PermitTunnel`|Allows tunneling|Can bypass firewalls|
|`DebianBanner yes`|Shows system info|Aids fingerprinting|

---

## Footprinting & Auditing

### ssh-audit

Tool to analyze SSH configurations and algorithms.

```bash
git clone https://github.com/jtesta/ssh-audit.git
cd ssh-audit
./ssh-audit.py <target_ip>
```

- Reveals banner (server version, protocol).

- Lists supported algorithms (key exchange, host key, ciphers).

- Highlights weak/insecure algorithms (e.g., RSA with SHA-1).


---

## Authentication Method Selection

Force specific authentication method during connection:

```bash
ssh user@host -o PreferredAuthentications=password
```

Useful in brute-force or testing scenarios.

---

## Banners

- **SSH-1.99-OpenSSH_3.9p1** → supports SSH-1 and SSH-2.

- **SSH-2.0-OpenSSH_8.2p1** → only supports SSH-2.


---

## Related Tools & Services

### Rsync

- File synchronization tool (default port **873**).

- Uses **delta-transfer algorithm** → transfers only file differences.

- Can be combined with SSH (`-e ssh`) for secure transfers.


Example enumeration:

```bash
nmap -sV -p 873 <target>
rsync -av --list-only rsync://<target>/share
```

Potential abuse: accessing sensitive files (SSH keys, configs, backups).

---

### R-Services (Legacy, Insecure)

Older remote management protocols (replaced by SSH). Transmit data in plaintext.

Ports: **512, 513, 514**

#### Common Commands

|Command|Daemon|Port|Description|
|---|---|---|---|
|`rcp`|rshd|514|Remote file copy|
|`rsh`|rshd|514|Remote shell, no login|
|`rexec`|rexecd|512|Remote command execution|
|`rlogin`|rlogind|513|Remote login (like telnet)|

#### Trusted Relationships

- `/etc/hosts.equiv` (system-wide trust).

- `.rhosts` (per-user trust).

- Entries: `<username> <hostname/ip>`

- `+` wildcard = trust all (dangerous).


#### Enumeration

```bash
nmap -sV -p 512,513,514 <target>
```

## Security Hardening Recommendations

- Disable password authentication (`PasswordAuthentication no`).

- Disable root login (`PermitRootLogin no`).

- Enforce SSH-2 only.

- Use key-based authentication with passphrases.

- Disable unused features (X11Forwarding, TCP forwarding, tunneling).

- Regularly audit with **ssh-audit**.

- Monitor logs for brute-force attempts.


---

## sum

SSH is a critical protocol for secure remote management.

- Secure by default, but misconfigurations can weaken it.

- Always verify authentication methods and cipher strength.

- Related tools like Rsync can inherit SSH’s strengths/weaknesses.

- Legacy services (R-services) should be avoided but may still be encountered.
