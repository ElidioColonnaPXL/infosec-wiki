# Snort

## Overview

Snort is an open-source **IDS/IPS** that can also be used for **packet logging** and **traffic inspection**. In Snort 3, configuration is done in **Lua**, and rules determine what traffic should generate alerts or actions. ([docs.snort.org][1])

## Main Use Cases

* **Passive IDS** — observe and alert
* **Inline IPS** — inspect and block
* **PCAP analysis** — run Snort against saved traffic
* **Live traffic inspection** — listen on network interfaces

Snort decides passive vs inline mainly from the command line and DAQ settings. Using `-r` or `-i` runs in passive mode by default; `-Q` enables inline mode if the DAQ supports it. `afpacket` is one supported inline DAQ on Linux. ([docs.snort.org][2])

---

## How Snort 3 Works

Snort 3 is best understood as a set of **modules** configured in `snort.lua`. The official docs describe eight main module types:

* **Basic modules** — basic traffic and rule processing
* **Codec modules** — decode protocols and detect anomalies
* **Inspector modules** — analyze and process protocols
* **IPS action modules** — actions taken when an event occurs
* **IPS option modules** — rule options used in detection
* **Search engine** — pattern matching against traffic
* **SO rule modules** — advanced detection logic
* **Logger modules** — output events and packet data

That is the Snort 3 equivalent of the older “decoder / preprocessor / detection / logging” view. ([docs.snort.org][1])

---

## Operation Modes

### Passive mode

* Snort inspects traffic and alerts
* It does **not block**
* Common when using:

  * `-r` for PCAP files
  * `-i` for live interface capture

### Inline mode

* Snort can **block** traffic
* Requires inline-capable DAQ support
* Common example: `afpacket` with `-Q`

Snort documents these two as the main runtime modes. ([docs.snort.org][2])

---

## Configuration

Snort 3 configuration is done in **Lua** and can be supplied:

* from the command line
* through one Lua config file
* through multiple Lua config files

The default base configuration is built around:

* `snort.lua`
* `snort_defaults.lua`

These files define variables, modules, logging behavior, and rule inclusion. ([docs.snort.org][1])

### Main config file

```bash
/root/snorty/etc/snort/snort.lua
```

### Common things configured in `snort.lua`

* network variables such as `HOME_NET` and `EXTERNAL_NET`
* enabled modules
* inspection behavior
* output / alert logging
* included rules files

---

## DAQ

Snort uses **LibDAQ** as its data acquisition layer. It is the abstraction layer that lets Snort read from packet files, network interfaces, or inline packet sources. Snort’s installation guide notes that LibDAQ must be installed and that non-standard library locations may need to be passed explicitly. ([docs.snort.org][3])

---

## Modules

To see available modules:

```bash
snort --help-modules
```

To view a module’s settings:

```bash
snort --help-config arp_spoof
```

In Snort 3, modules are configured as Lua tables. An empty table means the module uses default settings.

Example:

```lua
stream_tcp = { }
```

That enables the module with defaults. ([docs.snort.org][1])

---

## Rules

Snort rules have two main parts:

* **header**
* **rule body / options**

The rule header defines:

* action
* protocol
* source IP
* source port
* direction
* destination IP
* destination port

Example:

```snort
alert tcp $EXTERNAL_NET 80 -> $HOME_NET any
```

The body contains the detection logic, such as `msg`, `content`, `pcre`, `classtype`, and `sid`. ([docs.snort.org][4])

### Adding rules in `snort.lua`

```lua
ips =
{
    { variables = default_variables, include = '/home/htb-student/local.rules' }
}
```

### Loading rules from the command line

Single rule file:

```bash
snort -R /home/htb-student/local.rules
```

Rules directory:

```bash
snort --rule-path /path/to/rules/
```

Snort documents both approaches. ([docs.snort.org][5])

---

## Inputs

## Offline input

Use `-r` to inspect a PCAP file.

## Live input

Use `-i` to listen on a network interface.

## Inline input

Use `-Q` with an inline-capable DAQ such as `afpacket`.

---

## Outputs

Snort produces several kinds of output.

### Statistics

On shutdown, Snort prints:

* packet statistics
* module statistics
* summary statistics

### Alerts

To see detection events, use `-A`.

Common alert modes:

* `-A cmg` — alert text plus packet headers and payload
* `-A u2` — Unified2 binary output
* `-A csv` — CSV output
* `-A alert_json` — JSON event output
* `-A alert_fast` — brief text alerts

Snort’s alert logging docs also note that `alert_json` and `alert_csv` can be customized to include additional fields. ([docs.snort.org][6])

To list logger plugins:

```bash
snort --list-plugins | grep logger
```

---

## Commands

## View configuration

```bash
sudo more /root/snorty/etc/snort/snort.lua
```

Shows the main Snort configuration file.

```bash
snort --help-modules
```

Lists available Snort 3 modules.

```bash
snort --help-config arp_spoof
```

Shows configuration options for a specific module.

---

## Validate configuration

```bash
snort -c /root/snorty/etc/snort/snort.lua --daq-dir /usr/local/lib/daq
```

Loads and validates the configuration.

> `--daq-dir` is useful when LibDAQ is installed in a non-default location. Snort’s install docs note that custom DAQ paths may need to be supplied explicitly. ([docs.snort.org][3])

---

## Read a PCAP file

```bash
sudo snort -c /root/snorty/etc/snort/snort.lua --daq-dir /usr/local/lib/daq -r /home/htb-student/pcaps/icmp.pcap
```

Runs Snort against a PCAP file in passive read-file mode. Snort documents `-r` as passive by default. ([docs.snort.org][2])

---

## Listen on a live interface

```bash
sudo snort -c /root/snorty/etc/snort/snort.lua --daq-dir /usr/local/lib/daq -i ens160
```

Runs Snort on interface `ens160` in passive mode. ([docs.snort.org][2])

---

## Run inline with `afpacket`

```bash
snort -Q --daq afpacket -i "eth0:eth1"
```

Runs Snort inline using `afpacket`. Snort’s docs specify that inline `afpacket` requires an interface pair in the `-i` argument. ([docs.snort.org][2])

---

## Enable rules in `snort.lua`

```lua
ips =
{
    { variables = default_variables, include = '/home/htb-student/local.rules' }
}
```

Includes `local.rules` directly from the Lua configuration. ([docs.snort.org][5])

---

## Load a rules file directly

```bash
sudo snort -c /root/snorty/etc/snort/snort.lua --daq-dir /usr/local/lib/daq -r /home/htb-student/pcaps/icmp.pcap -R /home/htb-student/local.rules -A cmg
```

Runs Snort on a PCAP and loads a standalone rules file from the command line. ([docs.snort.org][5])

---

## Show alerts with payload and headers

```bash
sudo snort -c /root/snorty/etc/snort/snort.lua --daq-dir /usr/local/lib/daq -r /home/htb-student/pcaps/icmp.pcap -A cmg
```

`-A cmg` shows:

* alert info
* packet headers
* payload dump

Snort documents `cmg` as equivalent to `fast -d -e`. ([Snort][7])

---

## JSON alerts

```bash
snort -q -R 3.rules -r log4j-exploit.pcap -A alert_json
```

Outputs JSON-formatted alert data.

Example with custom fields:

```bash
snort -q -R 3.rules -r log4j-exploit.pcap -A alert_json --lua "alert_json = {fields = 'timestamp pkt_num proto pkt_gen pkt_len dir src_ap dst_ap rule action msg class'}"
```

Snort documents the default fields and field customization for `alert_json`. ([docs.snort.org][6])

---

## CSV alerts

```bash
snort -q -R 3.rules -r log4j-exploit.pcap -A alert_csv --lua "alert_csv = {fields = 'timestamp pkt_num proto pkt_gen pkt_len dir src_ap dst_ap rule action msg class'}"
```

Outputs alert events in CSV format. ([docs.snort.org][6])

---

## Important Paths and Places

### Configuration

* `/root/snorty/etc/snort/snort.lua`
* `/root/snorty/etc/snort/snort_defaults.lua`

### Rules

* `/home/htb-student/local.rules`

### PCAPs

* `/home/htb-student/pcaps/icmp.pcap`

### DAQ

* `/usr/local/lib/daq`

### Interfaces

* `ens160`
* inline `afpacket` interface pair such as `"eth0:eth1"`

---

## Key Features

* deep packet inspection
* IDS and IPS support
* PCAP analysis
* live interface inspection
* Lua-based configuration
* modular architecture
* multiple alert formats including JSON, CSV, and Unified2
* IPv4 and IPv6 support

Snort’s configuration and alert logging docs emphasize the modular design, Lua configuration, and multiple logging outputs. ([docs.snort.org][1])

---

## Sources

* Snort configuration and modules. ([docs.snort.org][1])
* Snort reading traffic and inline mode. ([docs.snort.org][2])
* Snort rules and rule inclusion. ([docs.snort.org][5])
* Snort alert logging. ([docs.snort.org][6])
* Snort installation and LibDAQ. ([docs.snort.org][3])

Send the next firewall topic and I’ll keep the same format.

[1]: https://docs.snort.org/start/configuration "Configuration - Snort 3 Rule Writing Guide"
[2]: https://docs.snort.org/start/inspection "Reading Traffic - Snort 3 Rule Writing Guide"
[3]: https://docs.snort.org/start/installation "Installing Snort - Snort 3 Rule Writing Guide"
[4]: https://docs.snort.org/rules/?utm_source=chatgpt.com "The Basics - Snort 3 Rule Writing Guide"
[5]: https://docs.snort.org/start/rules "Rules - Snort 3 Rule Writing Guide"
[6]: https://docs.snort.org/start/alert_logging "Alert Logging - Snort 3 Rule Writing Guide"
[7]: https://snort.org/downloads/snortplus/snort_manual.pdf "Snort 3 User Manual"
