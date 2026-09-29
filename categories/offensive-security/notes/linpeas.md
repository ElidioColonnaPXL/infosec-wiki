# LinPEAS

`LinPEAS` is a powerful enumeration tool designed to automatically detect possible privilege escalation vectors on Linux systems. It's part of the [Privilege Escalation Awesome Scripts Suite - Next Generation](https://github.com/peass-ng/PEASS-ng) (`PEASS-ng`) toolkit.

The script performs comprehensive checks across the system, highlighting potential security issues with color-coded outputs for better visualization based on severity:

- `Red`: Highly probable privilege escalation vectors
- `Yellow`: Potential privilege escalation vectors that require further analysis
- `Green`: General information useful for manual enumeration

Key features of LinPEAS include, but not limited to:

- Automated detection of common privilege escalation vectors

- Identification of misconfigurations in services, cron jobs, and SUID/SGID binaries

- Detection of credentials in files, environment variables, or process memory

- Checking for vulnerable software versions and known kernel exploits

- Analysis of sudo privileges and other permission-related issues

- Enumeration of sensitive information that could aid lateral movement
-
