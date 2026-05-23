
# Disk Forensics

| Category | Details |
|---|---|
| Topic | Memory Forensics / Volatile Memory Analysis |
| Goal | Analyze RAM captures to identify processes, malware artifacts, network activity, injected code, handles, services, DLLs, registry hives, and rootkit behavior |
| Main Tool | Volatility Framework |
| Evidence Type | Memory dump / RAM image |
| Example Dump | `Win7-2515534d.vmem`, `rootkit.vmem` |
| Main Use Case | Incident response, malware investigation, rootkit detection, process and network artifact analysis |

---

## Tool Summary

| Name | Use Case | Link |
|---|---|---|
| Volatility v2 | Memory dump analysis using profiles and plugins | https://github.com/volatilityfoundation/volatility/wiki/Command-Reference |
| Volatility v3 | Newer Volatility framework with improved symbol/profile handling | https://volatility3.readthedocs.io/en/latest/index.html |
| Volatility Cheatsheet | Quick reference for Volatility v2 and v3 commands | https://blog.onfvp.com/post/volatility-cheatsheet/ |
| strings | Extract readable strings from memory dumps | https://man7.org/linux/man-pages/man1/strings.1.html |
| grep | Filter strings using patterns and regular expressions | https://man7.org/linux/man-pages/man1/grep.1.html |
| Sysinternals Strings | Windows alternative for extracting strings | https://learn.microsoft.com/en-us/sysinternals/downloads/strings |

---

## Concept Summary

Memory forensics is the analysis of volatile memory, also known as RAM.

Unlike disk forensics, which focuses on stored files and filesystem artifacts, memory forensics focuses on the live state of a system at the moment the memory image was captured.

RAM can contain:

- Running processes
- Network connections
- Open files
- Open registry keys
- Loaded DLLs
- Loaded drivers
- Command history
- Console sessions
- User and credential artifacts
- Malware artifacts
- Encryption keys
- Process memory regions
- Kernel structures

Memory forensics is useful because malware often leaves runtime traces in memory even when it tries to hide from disk-based detection.

---

## Investigation Workflow

### 1. Identify Processes

Goal: find all active or recently active processes.

Look for:

- Suspicious process names
- Wrong parent-child relationships
- Misspelled legitimate process names
- Unexpected process paths
- Malware running as a normal-looking process

Useful plugins:

- `pslist`
- `pstree`
- `psscan`
- `cmdline`

---

### 2. Inspect Process Components

Goal: analyze what the suspicious process loaded or touched.

Look for:

- Suspicious DLLs
- DLL injection
- Hijacked DLLs
- Strange file handles
- Registry keys used by the process

Useful plugins:

- `dlllist`
- `handles`
- `malfind`

---

### 3. Analyze Network Activity

Goal: identify active or previous network connections from memory.

Look for:

- External IP addresses
- C2 communication
- Listening ports
- Suspicious local ports
- Malware beaconing
- Connections tied to suspicious processes

Useful plugins:

- `netscan`
- `connscan`

---

### 4. Detect Code Injection

Goal: find injected code, process hollowing, or abnormal executable memory.

Look for:

- `PAGE_EXECUTE_READWRITE`
- Private executable memory
- Suspicious VAD regions
- Unmapped or hidden code sections

Useful plugin:

- `malfind`

---

### 5. Detect Rootkits

Goal: find hidden processes or kernel manipulation.

Rootkits may use DKOM, or Direct Kernel Object Manipulation, to unlink processes from normal Windows process lists.

Compare:

- `pslist` output
- `psscan` output

If a process appears in `psscan` but not in `pslist`, it may be hidden or terminated but still resident in memory.

Useful plugins:

- `pslist`
- `psscan`
- `psxview`

---

### 6. Extract Suspicious Artifacts

Goal: dump suspicious processes, DLLs, or memory regions for deeper analysis.

Useful plugins:

- `procdump`
- `memdump`
- `dlldump`
- `dumpfiles`

---

## Volatility Basics

Volatility uses plugins to extract specific artifacts from a memory image.

Basic syntax:

```bash
vol.py -f <memory_dump> --profile=<profile> <plugin>
````

Example:

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem --profile=Win7SP1x64 pslist
```

| Option      | Meaning                                  |
| ----------- | ---------------------------------------- |
| `vol.py`    | Runs Volatility v2                       |
| `-f`        | Specifies the memory dump file           |
| `--profile` | Tells Volatility which OS profile to use |
| `<plugin>`  | Defines what artifact to extract         |

---

## Commands Explained

### Show Help

```bash
vol.py --help
```

Shows available options and plugins.

Use this when:

* You want to see supported plugins
* You forgot the syntax
* You want to check available output options

---

### Identify Memory Profile

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem imageinfo
```

Purpose:

* Identifies the probable operating system profile
* Required for Volatility v2
* Helps Volatility correctly interpret memory structures

Important output:

```text
Suggested Profile(s): Win7SP1x64, Win7SP0x64, ...
```

Use one of the suggested profiles in later commands.

Example:

```bash
--profile=Win7SP1x64
```

---

### List Running Processes

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem --profile=Win7SP1x64 pslist
```

Purpose:

* Lists active processes
* Shows PID, PPID, threads, handles, start time, and exit time

Use this to identify:

* Malware processes
* Suspicious parent-child relationships
* Processes with strange names
* Recently exited processes

Interesting examples from the course:

```text
Ransomware.wan
tasksche.exe
@WanaDecryptor@
taskhsvc.exe
```

These are suspicious because they are related to ransomware behavior.

---

### Scan for Network Connections

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem --profile=Win7SP1x64 netscan
```

Purpose:

* Finds network connections and open ports
* Maps connections to PIDs and process names

Use this to identify:

* Listening ports
* Established connections
* Suspicious local or remote communication
* Malware C2 activity

Important fields:

| Field           | Meaning                        |
| --------------- | ------------------------------ |
| Proto           | Protocol used, e.g. TCP or UDP |
| Local Address   | Local IP and port              |
| Foreign Address | Remote IP and port             |
| State           | Connection state               |
| PID             | Process ID                     |
| Owner           | Process name                   |

Suspicious example:

```text
127.0.0.1:9050 LISTENING taskhsvc.exe
```

Port `9050` is often associated with SOCKS/Tor-style proxy behavior, so it should be investigated.

---

### Scan Old TCP Connections

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem --profile=Win7SP1x64 connscan
```

Purpose:

* Finds TCP connection artifacts using pool tag scanning
* Can recover previous connections that are no longer active

Use this when:

* `netscan` does not show enough
* You want to find terminated connections
* You suspect malware connected earlier but is now inactive

---

### Detect Injected Code

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem --profile=Win7SP1x64 malfind --pid=608
```

Purpose:

* Detects injected code or suspicious memory regions in a process

Use this to identify:

* Code injection
* Process hollowing
* Suspicious executable memory
* Malware loaded inside another process

Important indicators:

```text
Vad Tag: VadS
Protection: PAGE_EXECUTE_READWRITE
PrivateMemory: 1
```

`PAGE_EXECUTE_READWRITE` is suspicious because memory that is writable and executable can be used by malware to run injected code.

---

### Show Process Handles - Registry Keys

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem --profile=Win7SP1x64 handles -p 1512 --object-type=Key
```

Purpose:

* Shows registry keys opened by a process

Use this to identify:

* Persistence attempts
* Registry modification
* Configuration access
* Malware touching system/user settings

Example:

```text
MACHINE\SOFTWARE\MICROSOFT\WINDOWS NT\CURRENTVERSION\IMAGE FILE EXECUTION OPTIONS
```

This registry area is interesting because it can be abused for persistence or execution redirection.

---

### Show Process Handles - Files

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem --profile=Win7SP1x64 handles -p 1512 --object-type=File
```

Purpose:

* Shows files opened by a process

Use this to identify:

* Files accessed by malware
* Working directory
* Dropped files
* Temporary files
* Touched system paths

Example:

```text
\Device\HarddiskVolume2\Users\Analyst\Desktop\Samples
```

This can help locate where the malware sample was executed from.

---

### Show Process Handles - Processes

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem --profile=Win7SP1x64 handles -p 1512 --object-type=Process
```

Purpose:

* Shows process handles opened by a process

Use this to identify:

* Process interaction
* Injection targets
* Child or related processes
* Malware controlling another process

Example:

```text
tasksche.exe(2972)
```

This suggests process interaction between the ransomware process and `tasksche.exe`.

---

### List Windows Services

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem --profile=Win7SP1x64 svcscan | more
```

Purpose:

* Lists Windows services found in memory

Use this to identify:

* Running services
* Stopped services
* Suspicious service names
* Malicious services
* Persistence through services

Important fields:

| Field         | Meaning                 |
| ------------- | ----------------------- |
| Service Name  | Internal service name   |
| Display Name  | Human-readable name     |
| Service State | Running or stopped      |
| Binary Path   | Executable path         |
| Process ID    | PID running the service |

---

### List Loaded DLLs

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem --profile=Win7SP1x64 dlllist -p 1512
```

Purpose:

* Lists DLLs loaded by a specific process

Use this to identify:

* Suspicious DLLs
* DLL injection
* Unusual library paths
* Malware dependencies
* Process architecture, e.g. 32-bit on 64-bit system

Example:

```text
Ransomware.wannacry.exe
C:\Windows\SysWOW64\ntdll.dll
C:\Windows\syswow64\kernel32.dll
C:\Windows\syswow64\WININET.dll
```

`WININET.dll` is interesting because it can indicate internet/network functionality.

---

### List Registry Hives

```bash
vol.py -f /home/htb-student/MemoryDumps/Win7-2515534d.vmem --profile=Win7SP1x64 hivelist
```

Purpose:

* Lists registry hives loaded in memory

Use this to identify:

* SYSTEM hive
* SOFTWARE hive
* SAM hive
* SECURITY hive
* User hives like `NTUSER.DAT`

Important examples:

```text
\REGISTRY\MACHINE\SYSTEM
\SystemRoot\System32\Config\SOFTWARE
\SystemRoot\System32\Config\SAM
\SystemRoot\System32\Config\SECURITY
\??\C:\Users\Analyst\ntuser.dat
```

These hives are useful for investigating persistence, users, services, and system configuration.

---

## Rootkit Analysis

### EPROCESS

`EPROCESS` is a Windows kernel structure that represents a process.

Each process has an `EPROCESS` block in kernel memory.

Important field:

```text
ActiveProcessLinks
```

This field links processes together in a doubly-linked list.

---

### FLINK and BLINK

| Field | Meaning                                                   |
| ----- | --------------------------------------------------------- |
| FLINK | Points to the next process in the active process list     |
| BLINK | Points to the previous process in the active process list |

Windows uses these links to enumerate active processes.

---

### DKOM

DKOM stands for Direct Kernel Object Manipulation.

Rootkits can use DKOM to modify kernel structures directly.

Example:

* A rootkit unlinks a malicious process from `ActiveProcessLinks`
* Normal tools using the active process list do not see it
* Memory scanning tools may still recover it

---

### Detect Hidden Processes with `psscan`

```bash
vol.py -f /home/htb-student/MemoryDumps/rootkit.vmem psscan
```

Purpose:

* Scans memory pool tags for EPROCESS structures
* Can find hidden or terminated processes
* Useful against DKOM-style rootkits

Compare with:

```bash
vol.py -f /home/htb-student/MemoryDumps/rootkit.vmem pslist
```

Interpretation:

| Result                                          | Meaning                                  |
| ----------------------------------------------- | ---------------------------------------- |
| Process appears in `pslist` and `psscan`        | Normal active process                    |
| Process appears in `psscan` but not in `pslist` | Possibly hidden, unlinked, or terminated |
| Process has an exit time                        | Process already terminated               |
| Suspicious process name                         | Investigate further                      |

Example from the course:

```text
test.exe
```

`test.exe` was visible in `psscan` but not in `pslist`, which suggests it was hidden from the normal process list.

---

## Strings Analysis

Strings analysis extracts readable text from memory.

This is useful for finding:

* IP addresses
* Email addresses
* File paths
* Commands
* Malware names
* Usernames
* Domains
* Password-like strings
* C2 indicators

---

### Find IPv4 Addresses

```bash
strings /home/htb-student/MemoryDumps/Win7-2515534d.vmem | grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
```

Purpose:

* Extracts readable strings
* Filters for IPv4-like patterns

Use this to find:

* Local IPs
* Remote IPs
* Possible C2 infrastructure
* Network configuration artifacts

Example output:

```text
212.83.154.33
10.10.10.1
192.168.182.254
```

---

### Find Email Addresses

```bash
strings /home/htb-student/MemoryDumps/Win7-2515534d.vmem | grep -oE "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\b"
```

Purpose:

* Extracts email-like strings from memory

Use this to find:

* User accounts
* Email artifacts
* Contacted addresses
* Malware strings
* False positives from DLL/resource data

Note: not every match is valid evidence. Some strings may come from binaries, certificates, or random memory.

---

### Find Command Prompt or PowerShell Artifacts

```bash
strings /home/htb-student/MemoryDumps/Win7-2515534d.vmem | grep -E "(cmd|powershell|bash)[^\s]+"
```

Purpose:

* Finds command-line artifacts in memory

Use this to identify:

* Executed commands
* Script activity
* Malware launch commands
* Shell usage
* Suspicious command chains

Example:

```text
cmd.exe /c "C:\Intel\ueqzlhmlwuxdg271\tasksche.exe"
cmd.exe /c start /b @WanaDecryptor@.exe vs
```

These commands are suspicious because they show execution of ransomware-related files.

---

## Useful Plugin Overview

| Plugin      | Purpose                                                       |
| ----------- | ------------------------------------------------------------- |
| `imageinfo` | Suggests the correct Volatility v2 profile                    |
| `pslist`    | Lists active processes using the normal process list          |
| `pstree`    | Shows process parent-child relationships                      |
| `psscan`    | Scans memory for process objects, useful for hidden processes |
| `psxview`   | Compares multiple process enumeration methods                 |
| `cmdline`   | Shows process command-line arguments                          |
| `netscan`   | Finds network connections and listening ports                 |
| `connscan`  | Finds TCP artifacts, including old connections                |
| `malfind`   | Finds injected or suspicious executable memory                |
| `handles`   | Lists open handles for files, registry keys, and objects      |
| `svcscan`   | Lists Windows services from memory                            |
| `dlllist`   | Lists DLLs loaded by a process                                |
| `hivelist`  | Lists registry hives in memory                                |
| `procdump`  | Dumps a process executable                                    |
| `memdump`   | Dumps process memory                                          |
| `dlldump`   | Dumps DLLs from process memory                                |
| `dumpfiles` | Extracts cached or mapped files from memory                   |
| `yarascan`  | Scans memory using YARA rules                                 |

---

## Practical Investigation Order

```text
1. Identify profile
2. List processes
3. Check process tree
4. Look for suspicious names and parent-child relations
5. Check network connections
6. Inspect DLLs and handles
7. Run malfind on suspicious PIDs
8. Compare pslist with psscan for hidden processes
9. Extract suspicious artifacts
10. Use strings and grep for quick IOC hunting
```

---

## Red Flags

Look for:

* Malware-like names: `Ransomware.wan`, `@WanaDecryptor@`
* Suspicious paths: `C:\Users\...\Desktop\Samples`
* Strange parent-child relationships
* Processes with network activity that should not communicate externally
* `PAGE_EXECUTE_READWRITE` memory
* Processes visible in `psscan` but missing from `pslist`
* Suspicious services
* Strange DLL paths
* Command artifacts launching unknown binaries
* Local proxy ports such as `127.0.0.1:9050`

---

