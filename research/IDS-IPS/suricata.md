# Suricata

## Overview

[Suricata](https://suricata.io/) is an open-source network security engine developed by the [Open Information Security Foundation (OISF)](https://oisf.net/). It can be used for **IDS**, **IPS**, **NSM**, and **offline PCAP analysis**. Suricata inspects traffic using **rules**, then logs, alerts, or blocks depending on the selected mode and rule action. ([docs.suricata.io][1])

## Modes

### IDS

* Passive monitoring
* Generates alerts
* Does not block traffic

### IPS

* Inline inspection
* Can block or drop malicious traffic
* Requires careful tuning to avoid false positives

### IDPS

* Hybrid approach
* Monitors traffic and can actively respond in certain cases

### NSM

* Focused on logging and visibility
* Useful for investigations, threat hunting, and forensics

## Inputs

### Offline Input

Used to inspect **PCAP files**.
Useful for:

* post-incident analysis
* rule testing
* lab work

### Live Input

Used to inspect **real-time traffic** from an interface.

Common live input methods:

* **LibPCAP** — simple, but lower performance
* **NFQ** — inline Linux mode with `iptables`
* **AF_PACKET** — faster and commonly preferred on Linux

## Outputs

Suricata writes several useful logs by default.

### `eve.json`

Main JSON log file.
Contains event types such as:

* alerts
* DNS
* HTTP
* TLS
* flows
* drops

This is the most useful log for SIEM ingestion and analysis. ([docs.suricata.io][1])

### `fast.log`

* Text-based
* Alerts only
* Good for quick review

### `stats.log`

* Human-readable statistics
* Useful for troubleshooting and tuning

## Rules and Variables

Suricata uses **rules** to decide what to detect, log, extract, or block. Rule structure and behavior are documented in the official Suricata rules guide. Common variables include:

* `$HOME_NET` — internal network
* `$EXTERNAL_NET` — everything outside the internal network

These are usually defined in `suricata.yaml`. ([docs.suricata.io][2])

## Configuration

Main configuration file:

```bash
/etc/suricata/suricata.yaml
```

This file controls:

* network variables
* enabled outputs
* rule files
* live reload settings
* file extraction settings

Custom rules are often placed in a separate file such as:

```bash
/home/htb-student/local.rules
```

## File Extraction

Suricata can extract transferred files from supported protocols. This is useful for:

* malware analysis
* threat hunting
* forensic analysis

To enable it in `suricata.yaml`:

```yaml
file-store:
  version: 2
  enabled: yes
  force-filestore: yes
```

Example rule:

```text
alert http any any -> any any (msg:"FILE store all"; filestore; sid:2; rev:1;)
```

Extracted files are stored by **SHA256 hash** inside the `filestore/` directory.

## Live Rule Reloading

Suricata can reload rules without stopping inspection.

In `suricata.yaml`:

```yaml
detect-engine:
  - reload: true
```

Then signal the running process to reload the rules.

## Rule Updates

Rules can be updated with `suricata-update`. Suricata supports multiple rule providers, including **Emerging Threats Open**. The official docs also cover source management and rule updates. ([docs.suricata.io][1])

## Validation

Always validate the configuration after making changes:

```bash
sudo suricata -T -c /etc/suricata/suricata.yaml
```

This checks whether the configuration loads correctly and whether referenced files are accessible.

---

## Commands

### Rule files and configuration

```bash
ls -lah /etc/suricata/rules/
```

Lists available rule files.

```bash
more /etc/suricata/rules/emerging-malware.rules
```

Opens a rule file for inspection.

```bash
more /etc/suricata/suricata.yaml
```

Displays the main Suricata configuration.

```bash
sudo vim /etc/suricata/suricata.yaml
```

Edits the main configuration file.

### Offline PCAP analysis

```bash
suricata -r /home/htb-student/pcaps/suspicious.pcap
```

Runs Suricata against a PCAP file.

```bash
suricata -r /home/htb-student/pcaps/suspicious.pcap -k none -l .
```

Runs offline analysis:

* `-k none` disables checksum validation
* `-l .` writes logs to the current directory

```bash
suricata -r /home/htb-student/pcaps/vm-2.pcap
```

Processes another PCAP, for example for file extraction testing.

### Interface discovery

```bash
ifconfig
```

Shows available interfaces and IP details.

### Live capture

```bash
sudo suricata --pcap=ens160 -vv
```

Runs Suricata in live LibPCAP mode on `ens160`.

```bash
sudo suricata -i ens160
```

Runs Suricata on interface `ens160`.

```bash
sudo suricata --af-packet=ens160
```

Runs Suricata with AF_PACKET on `ens160`.

### Inline IPS with NFQ

```bash
sudo iptables -I FORWARD -j NFQUEUE
```

Sends forwarded packets to NFQUEUE for inline inspection.

```bash
sudo suricata -q 0
```

Starts Suricata in NFQ mode on queue `0`.

### Replay traffic

```bash
sudo tcpreplay -i ens160 /home/htb-student/pcaps/suspicious.pcap
```

Replays a PCAP onto an interface so Suricata can inspect it as live traffic. For `tcpreplay`, see the [official site](https://tcpreplay.appneta.com/). ([tcpreplay.appneta.com][3])

### Log inspection

```bash
less /var/log/suricata/old_eve.json
```

Views the JSON event log.

```bash
cat /var/log/suricata/old_eve.json | jq -c 'select(.event_type == "alert")'
```

Filters only alert events from `eve.json`.

```bash
cat /var/log/suricata/old_eve.json | jq -c 'select(.event_type == "dns")' | head -1 | jq .
```

Shows the first DNS event in readable form.

```bash
cat /var/log/suricata/old_fast.log
```

Shows alert-only log entries.

```bash
cat /var/log/suricata/old_stats.log
```

Shows statistics and counters.

For `jq`, see the [official manual](https://jqlang.org/manual/). ([jq][4])

### File extraction inspection

```bash
cd filestore
```

Moves into the file extraction directory.

```bash
find . -type f
```

Lists extracted files.

```bash
xxd ./21/21742fc621f83041db2e47b0899f5aea6caa00a4b67dbff0aae823e6817c5433 | head
```

Shows the first bytes of an extracted file to help identify file type.

### Reloading and updating rules

```bash
sudo kill -usr2 $(pidof suricata)
```

Reloads rules without a full restart.

```bash
sudo suricata-update
```

Downloads and updates Suricata rules.

```bash
sudo suricata-update list-sources
```

Lists available rule providers.

```bash
sudo suricata-update enable-source et/open
```

Enables the `et/open` ruleset source.

```bash
sudo systemctl restart suricata
```

Restarts the Suricata service.

### Validation

```bash
sudo suricata -T -c /etc/suricata/suricata.yaml
```

Validates the Suricata configuration.

---

## Important Paths and Places

### Configuration

* `/etc/suricata/suricata.yaml`
* `/home/htb-student/local.rules`

### Rules

* `/etc/suricata/rules/`
* `/etc/suricata/rules/emerging-malware.rules`

### Logs

* `/var/log/suricata/`
* `/var/log/suricata/eve.json`
* `/var/log/suricata/fast.log`
* `/var/log/suricata/stats.log`
* `/var/log/suricata/suricata.log`

### Rule updates

* `/var/lib/suricata/`
* `/var/lib/suricata/rules/`
* `/var/lib/suricata/update/cache/index.yaml`
* `/var/lib/suricata/update/sources/`

### Runtime

* `/var/run/suricata/suricata-command.socket`

### File extraction

* `filestore/`

### PCAP files

* `/home/htb-student/pcaps/suspicious.pcap`
* `/home/htb-student/pcaps/vm-2.pcap`

### Network / firewall points

* `ens160`
* `lo`
* `FORWARD` chain in `iptables`
* `NFQUEUE`

---

## Sources

* [Suricata Documentation](https://docs.suricata.io/)
* [OISF](https://oisf.net/)
* [Suricata Project](https://suricata.io/)
* [Suricata Rules Documentation](https://docs.suricata.io/en/latest/rules/index.html)
* [jq Manual](https://jqlang.org/manual/)
* [tcpreplay](https://tcpreplay.appneta.com/)

[1]: https://docs.suricata.io/?utm_source=chatgpt.com "Suricata User Guide — Suricata 8.0.4 documentation"
[2]: https://docs.suricata.io/en/latest/rules/index.html?utm_source=chatgpt.com "8. Suricata Rules — Suricata 9.0.0-dev documentation"
[3]: https://tcpreplay.appneta.com/?utm_source=chatgpt.com "Tcpreplay - Pcap editing and replaying utilities"
[4]: https://jqlang.org/manual/?utm_source=chatgpt.com "jq 1.8 Manual"
