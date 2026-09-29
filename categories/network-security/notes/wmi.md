# WMI

Windows Fundamentals


# WMI

## Overview

**Windows Management Instrumentation (WMI)** is Microsoft’s implementation and extension of the **Common Information Model (CIM)** within the **WBEM (Web-Based Enterprise Management)** standard.

- Provides read and write access to nearly all Windows system settings.

- Critical for administration and remote maintenance of both PCs and servers.

- Accessible via:

    - **PowerShell**

    - **VBScript**

    - **Windows Management Instrumentation Console (WMIC)**

- Not a single program, but a collection of:

    - Services

    - Providers

    - Repositories (databases storing management information)


---

## Capabilities

- Query system information (hardware, OS, processes, services).

- Configure system settings.

- Execute commands remotely.

- Automate administrative tasks.

- Integrate with monitoring and management tools.


---

## Footprinting the Service

- **Initialization:** WMI uses **TCP port 135** (RPC endpoint mapper).

- **Communication:** After connection setup, traffic is moved to a **random port** (dynamic RPC).

- **Authentication:** Uses Windows authentication (local/domain accounts).


### Example: Impacket `wmiexec.py`

```bash
wmiexec.py example-user@192.0.2.10 "hostname"
```

Example output:

```
Impacket v0.9.22 - Copyright 2020 SecureAuth Corporation

[*] SMBv3.0 dialect used
ILF-SQL-01
```

---

## Offensive Security Use

- WMI is frequently abused during **post-exploitation** and **lateral movement**.

- Allows command execution similar to `psexec` but with different trade-offs:

    - Leaves fewer artifacts in `Service Control Manager` logs than `psexec`.

    - Generates WMI event logs (e.g., Microsoft-Windows-WMI-Activity/Operational).

- Common tools:

    - **Impacket’s wmiexec.py**

    - **PowerShell (Invoke-WmiMethod, Get-WmiObject)**


---

## Security Considerations

- **Risk:** Provides deep system access; attackers often use WMI for stealthy persistence and remote code execution.

- **Hardening Recommendations:**

    - Restrict WMI access to administrators only.

    - Audit and monitor WMI activity (e.g., via Windows Event Logs).

    - Implement least-privilege principles.

    - Segment networks to reduce lateral movement opportunities.

    - Disable or limit remote WMI if not required.


---

## Final Thoughts

WMI is one of the **most powerful and sensitive interfaces** on Windows systems:

- Indispensable for legitimate administration and automation.

- Widely abused by attackers for reconnaissance, remote execution, and persistence.

- Requires careful access control and monitoring to balance usability with security.


## Related

- Protocols Index
- Ports and Services
- Network Traffic Analysis
