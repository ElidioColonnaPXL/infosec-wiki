# WinRM

windows networking
Windows Fundamentals


# WinRM

## Overview

**Windows Remote Management (WinRM)** is a Microsoft protocol for remote management. It is based on **SOAP (Simple Object Access Protocol)** and is designed for administrative tasks over the command line.

- Ports:

    - **TCP 5985** → HTTP

    - **TCP 5986** → HTTPS

- Replaced earlier usage of ports 80/443 due to security issues.

- Enabled by default on **Windows Server 2012+**, but must be configured manually on older versions.

- Works with **Windows Remote Shell (WinRS)** to execute arbitrary commands remotely.

- Required for:

    - PowerShell remote sessions

    - Event log merging

    - Remote command execution


---

## Components

- **WinRM Service**

    - Core service that establishes SOAP-based communication.

- **WinRS (Windows Remote Shell)**

    - Allows execution of arbitrary commands on remote systems.

    - Present since Windows 7.


---

## Footprinting the Service

### Nmap Scan

Default ports: **5985 (HTTP)**, **5986 (HTTPS)**

```bash
nmap -sV -sC <target_ip> -p5985,5986 --disable-arp-ping -n
```

Example output:

```
PORT     STATE SERVICE VERSION
5985/tcp open  http    Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-title: Not Found
|_http-server-header: Microsoft-HTTPAPI/2.0
Service Info: OS: Windows
```

---

## Service Discovery

### On Windows

- **PowerShell cmdlet:**


```powershell
Test-WsMan <hostname>
```

Checks if a remote server is reachable via WinRM.

### On Linux (Pentest/Red Team)

- **evil-winrm**: A tool to interact with WinRM endpoints.


```bash
evil-winrm -i <target_ip> -u <username> -p <password>
```

Example session:

```
Evil-WinRM shell v3.3
Info: Establishing connection to remote endpoint
*Evil-WinRM* PS %USERPROFILE%\Documents>
```

---

## Security Notes

- WinRM must be explicitly enabled and properly configured (firewall exceptions included).

- Use **HTTPS (5986)** over HTTP (5985) to prevent credentials from being exposed in plaintext.

- Misconfigurations or weak credentials can allow attackers to gain remote code execution.

- Evil-WinRM is a preferred tool for exploitation during penetration testing.


---

## Final Thoughts

WinRM is powerful for remote management in Windows environments:

- Essential for automation and administrative tasks.

- Default in modern Windows servers.

- Secure if configured with HTTPS, proper authentication, and strict firewall rules.

- In offensive security, **evil-winrm** is one of the most effective tools for exploiting WinRM with stolen credentials.


---


## Related

- Protocols Index
- Ports and Services
- Network Traffic Analysis
