# Zeek Detection

## Overview

Zeek is especially strong for detection when the goal is not just to match a signature, but to **analyze behavior**, **correlate protocol activity**, and **pivot through structured logs**. Its event-driven model and scripting layer make it well suited for **beaconing detection**, **data exfiltration analysis**, and **multi-log investigation workflows**. ([docs.zeek.org][1])

In practice, Zeek detection often starts with logs such as `conn.log`, `dns.log`, `http.log`, `ssl.log`, `files.log`, `smb_files.log`, `dce_rpc.log`, and `smb_mapping.log`. Those logs are produced by Zeek’s protocol analyzers and logging framework, and they can be filtered with normal Unix tools or with `zeek-cut`. ([docs.zeek.org][2])

---

## Detection Approach

Zeek detection usually follows this pattern:

* run Zeek on a PCAP or live traffic
* identify the most useful log for the activity
* pivot on a small set of fields
* look for repeated structure, unusual volume, or suspicious protocol behavior
* correlate across multiple logs when needed

This approach fits Zeek’s design: the event engine turns packet streams into high-level events, and the scripting/logging layers expose those events as structured records for analysis. ([docs.zeek.org][3])

---

## Key Logs for Detection

### `conn.log`

Best starting point for:

* beaconing
* repeated connections
* unusual byte counts
* protocol/service pivots

Zeek documents `conn.log` as one of its most important logs and notes that it covers TCP, UDP, and ICMP activity. ([docs.zeek.org][4])

### `dns.log`

Best for:

* DNS tunneling
* suspicious subdomain volume
* unusual query naming patterns
* exfiltration via encoded labels

Zeek’s DNS base script tracks and logs DNS queries and responses, making `dns.log` the core source for DNS-based detection. ([docs.zeek.org][5])

### `http.log`

Best for:

* suspicious POST activity
* odd user-agents
* unusual URIs
* repeated C2 check-ins over HTTP

Zeek’s HTTP analysis records request and response metadata, including fields such as host, URI, referrer, user agent, and status information. ([docs.zeek.org][1])

### SMB / DCE-RPC logs

Best for:

* PsExec
* remote service creation
* ADMIN$ / IPC$ usage
* file transfer over SMB

When Zeek sees SMB traffic, it can generate `smb_files.log`, `smb_mapping.log`, `dce_rpc.log`, and related logs, which are often enough to reconstruct admin-tool or lateral-movement behavior. ([docs.zeek.org][6])

---

## Example 1 — Detecting Beaconing Malware

### Idea

Beaconing often shows up as:

* repeated outbound connections to the same destination
* stable timing intervals
* similar request sizes
* similar response sizes

`conn.log` is the main Zeek source for spotting this pattern because it records timestamps, source/destination pairs, service type, duration, and byte counts. ([docs.zeek.org][4])

### Command

```bash
/usr/local/zeek/bin/zeek -C -r /home/htb-student/pcaps/psempire.pcap
cat conn.log
```

### What to look for

In your sample, many HTTP connections go from `192.168.56.14` to `51.15.197.127:80` with very similar sizes and roughly regular timing. That kind of repeated structure is typical of a beacon rather than normal user browsing.

### Why Zeek is useful here

Zeek does not need a signature to show the behavior. The pattern is visible directly in the structured connection records, which makes it easy to validate with timestamps and byte counts. `conn.log` was built for this kind of session-level analysis. ([docs.zeek.org][4])

### Optional follow-up

```bash
scp htb-student@[TARGET IP]:/home/htb-student/pcaps/psempire.pcap .
```

---

## Example 2 — Detecting DNS Exfiltration

### Idea

DNS exfiltration often creates:

* many queries to one domain
* long or irregular subdomains
* repeated labels that look encoded
* many unique subdomains under the same parent domain

`dns.log` is the key Zeek source because it records the query names, query types, response data, and timing. ([docs.zeek.org][5])

### Commands

```bash
/usr/local/zeek/bin/zeek -C -r /home/htb-student/pcaps/dnsexfil.pcapng
cat dns.log
```

Focus on queried names:

```bash
cat dns.log | /usr/local/zeek/bin/zeek-cut query | cut -d . -f1-7
```

### What to look for

In your sample, the domain `letsgohunt.online` appears with a very large number of changing subdomains such as:

* `www.<encoded>...`
* `cdn.<encoded>...`
* `post.<encoded>...`

That is not normal browsing behavior. A high volume of generated-looking subdomains under one parent domain is a strong DNS tunneling / DNS exfiltration indicator.

### Why Zeek is useful here

Zeek makes this easy because `dns.log` gives you the exact queried names in a structured format, and `zeek-cut` lets you extract just the `query` field without manual column counting. Zeek’s log-format tooling is designed exactly for this style of pivot. ([docs.zeek.org][5])

### Optional follow-up

```bash
scp htb-student@[TARGET IP]:/home/htb-student/pcaps/dnsexfil.pcapng .
```

---

## Example 3 — Detecting TLS Exfiltration

### Idea

Even when traffic is encrypted, exfiltration can still stand out through:

* unusually large outbound byte counts
* repeated connections to one TLS destination
* one host dominating total transmitted volume

For this, `conn.log` is again the main source because it tracks per-connection byte counts. ([docs.zeek.org][4])

### Commands

```bash
/usr/local/zeek/bin/zeek -C -r /home/htb-student/pcaps/tlsexfil.pcap
cat conn.log
```

Aggregate sent bytes by source and destination:

```bash
cat conn.log | /usr/local/zeek/bin/zeek-cut id.orig_h id.resp_h orig_bytes | sort | grep -v -e '^$' | grep -v '-' | datamash -g 1,2 sum 3 | sort -k 3 -rn | head -10
```

### What to look for

This command groups traffic by:

* origin host
* responder host

and sums `orig_bytes`, which is the number of bytes sent by the originator. In your sample, the pair `10.0.10.100 -> 192.168.151.181` dominates the output, which is a strong exfiltration clue.

### Why Zeek is useful here

Zeek’s structured connection data lets you move from raw packets to host-pair aggregation very quickly. This is one of Zeek’s biggest strengths: even without decrypting the payload, you can still find suspicious transfer patterns through metadata and byte counts. `conn.log` is the foundation for that workflow. ([docs.zeek.org][4])

### Optional follow-up

```bash
scp htb-student@[TARGET IP]:/home/htb-student/pcaps/tlsexfil.pcap .
```

---

## Example 4 — Detecting PsExec

### Idea

A typical PsExec sequence often includes:

* writing `PSEXESVC.exe` to the `ADMIN$` share
* using `IPC$`
* creating and starting a temporary service via `svcctl` over DCE/RPC

Zeek can show this very clearly by combining `smb_files.log`, `dce_rpc.log`, and `smb_mapping.log`. Zeek’s SMB logging docs explicitly note that SMB traffic can generate all three of these logs. ([docs.zeek.org][6])

### Commands

```bash
/usr/local/zeek/bin/zeek -C -r /home/htb-student/pcaps/psexec_add_user.pcap
cat smb_files.log
cat dce_rpc.log
cat smb_mapping.log
```

### What to look for

From your sample:

* `smb_files.log` shows `PSEXESVC.exe` opened and deleted in `\\dc1\ADMIN$`
* `smb_mapping.log` shows `\\dc1\ADMIN$` and `\\dc1\IPC$`
* `dce_rpc.log` shows `svcctl` operations like:

  * `OpenSCManagerW`
  * `CreateServiceWOW64W`
  * `StartServiceW`
  * `DeleteService`

That combination is highly consistent with PsExec-style remote execution.

### Why Zeek is useful here

Instead of relying on a single IOC, Zeek lets you correlate:

* file transfer
* share access
* RPC service control activity

That is a much stronger detection pattern than any one event alone. Zeek’s SMB/DCE-RPC logging is specifically useful for reconstructing this kind of Windows admin-tool behavior. ([docs.zeek.org][6])

### Optional follow-up

```bash
scp htb-student@[TARGET IP]:/home/htb-student/pcaps/psexec_add_user.pcap .
```

---

## Useful Commands

### Run Zeek on a PCAP

```bash
/usr/local/zeek/bin/zeek -C -r /path/to/file.pcap
```

Processes a PCAP in offline mode and writes logs to the current directory. ([docs.zeek.org][7])

### View a full log

```bash
cat conn.log
cat dns.log
cat smb_files.log
```

Zeek logs are plain text TSV by default, so normal Unix tools work well. ([docs.zeek.org][8])

### Extract selected fields

```bash
cat dns.log | /usr/local/zeek/bin/zeek-cut query
cat conn.log | /usr/local/zeek/bin/zeek-cut id.orig_h id.resp_h orig_bytes
```

`zeek-cut` reads Zeek log headers and returns the requested fields by name. ([docs.zeek.org][8])

---

## Practical Notes

### Good detection habits

* start with `conn.log` for timing, volume, and flow patterns
* pivot to `dns.log` for suspected tunneling or odd naming
* use SMB and DCE-RPC logs together for lateral movement
* aggregate fields instead of reading raw packet dumps first
* correlate multiple logs before concluding malicious activity

These habits match Zeek’s design as a structured NSM platform rather than a packet-by-packet alerting engine. ([docs.zeek.org][1])

### Common signs worth investigating

* fixed-interval HTTP or TLS connections
* one host sending a disproportionate number of bytes to one destination
* very large numbers of generated-looking DNS subdomains
* `ADMIN$` + `IPC$` + `svcctl` in the same SMB/RPC sequence

Those are not always malicious, but they are strong candidates for deeper review.

---

## Sources

* Zeek logs overview. ([docs.zeek.org][9])
* `conn.log` reference. ([docs.zeek.org][4])
* DNS script reference. ([docs.zeek.org][5])
* Zeek log formats and `zeek-cut`. ([docs.zeek.org][8])
* SMB / DCE-RPC / SMB mapping logs. ([docs.zeek.org][6])
* Zeek scripting basics and event model. ([docs.zeek.org][3])


[1]: https://docs.zeek.org/ "Zeek Documentation — Book of Zeek (8.1.1)"
[2]: https://docs.zeek.org/en/current/logs/index.html "Zeek Logs — Book of Zeek (8.1.1)"
[3]: https://docs.zeek.org/en/v8.0.4/log-formats.html "Zeek Log Formats and Inspection"
[4]: https://docs.zeek.org/en/v8.0.4/logs/conn.html "conn.log — Book of Zeek (8.0.4)"
[5]: https://docs.zeek.org/en/current/scripts/base/protocols/dns/main.zeek.html "base/protocols/dns/main.zeek"
[6]: https://docs.zeek.org/en/v8.1.1/logs/smb.html "SMB Logs (plus DCE-RPC, Kerberos, NTLM)"
[7]: https://docs.zeek.org/en/current/quickstart.html "Quick Start Guide — Book of Zeek (8.1.1)"
[8]: https://docs.zeek.org/en/current/log-formats.html "Zeek Log Formats and Inspection"
[9]: https://docs.zeek.org/en/master/frameworks/notice.html "Notice Framework — Book of Zeek (8.2.0-dev.496)"
