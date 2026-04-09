# Snort Rules

## Overview

Snort rules are made of two main parts: a **header** and a **body**. The header decides **which traffic** the rule applies to, and the body contains the **conditions** that must be true before Snort generates an event. ([docs.snort.org][1])

## Basic Syntax

```snort
action protocol src_ip src_port -> dst_ip dst_port (options;)
```

Example:

```snort
alert tcp $EXTERNAL_NET 80 -> $HOME_NET any (msg:"Example"; sid:1000001; rev:1;)
```

The header contains the action, protocol, addresses, ports, and direction operator. Rule options are written inside parentheses and end with semicolons. ([docs.snort.org][2])

---

## Core Rule Syntax

### Header

The header filters traffic before Snort evaluates the body. Typical parts are:

* **action** — what Snort does when the rule matches
* **protocol** — `ip`, `icmp`, `tcp`, or `udp`
* **source / destination IP**
* **source / destination port**
* **direction** — usually `->` ([docs.snort.org][2])

Example:

```snort
alert tcp $HOME_NET any -> $EXTERNAL_NET 80
```

### `flow`

`flow` checks session properties such as direction and whether the traffic belongs to an established connection. It is commonly used to reduce noise and make rules more precise. ([docs.snort.org][3])

Examples:

```snort
flow:established,to_server;
flow:established,from_server;
```

### `content`

`content` performs literal string or hex matching. It is the base keyword for most Snort signatures. Snort also supports modifiers such as `fast_pattern`, `nocase`, `offset`, `depth`, `distance`, and `within`. ([docs.snort.org][4])

Examples:

```snort
content:"GET";
content:"|0d 0a|";
content:"User-Agent",nocase;
```

### `fast_pattern`

`fast_pattern` tells Snort which `content` match to use for fast prefiltering. If you do not set it manually, Snort usually picks one automatically, but the docs note that the longest string is not always the best choice. ([docs.snort.org][5])

### `offset`, `depth`, `distance`, `within`

These modifiers control **where** Snort searches for a match:

* `offset` — start searching from this byte
* `depth` — search only this far from the start
* `distance` — start searching relative to the previous match
* `within` — maximum window relative to the previous match ([docs.snort.org][6])

### `pcre`

`pcre` uses a Perl-compatible regular expression. Snort recommends pairing `pcre` with at least one `content` match for performance. In Snort 3, HTTP-specific PCRE flags are no longer needed because HTTP inspection uses sticky buffers. ([docs.snort.org][7])

### HTTP sticky buffers

In Snort 3, most HTTP rule options are **sticky buffers**. That means you first select the part of the HTTP message you want to inspect, then apply `content` or `pcre` to that buffer. Common examples are:

* `http_method`
* `http_uri`
* `http_header`
* `http_client_body` ([docs.snort.org][8])

Examples:

```snort
http_method; content:"POST";
http_uri; content:"/admin.php";
http_header:field user-agent; content:"python-requests";
http_client_body; content:"filename=";
```

Snort documents `http_uri` as the **normalized** URI buffer, `http_header` as the **normalized** header buffer, and `http_client_body` as the **normalized** request-body buffer. ([docs.snort.org][9])

### `dsize`

`dsize` checks packet payload size. It can be used for exact values, ranges, or inequality comparisons. ([docs.snort.org][10])

### `detection_filter`

`detection_filter` delays alerting until a rule has matched often enough within a time window. It is useful when one packet alone is weak evidence, but repeated matches are suspicious. ([docs.snort.org][11])

### `classtype`

`classtype` assigns an attack category and ties the event to Snort’s built-in priority scheme. ([docs.snort.org][12])

---

# Snort Rule Development Examples

## Example 1 — Detecting Ursnif (Inefficient)

```snort
alert tcp any any -> any any (msg:"Possible Ursnif C2 Activity"; flow:established,to_server; content:"/images/", depth 12; content:"_2F"; content:"_2B"; content:"User-Agent|3a 20|Mozilla/4.0 (compatible|3b| MSIE 8.0|3b| Windows NT"; content:!"Accept"; content:!"Cookie|3a|"; content:!"Referer|3a|"; sid:1000002; rev:1;)
```

### What it matches

This rule looks for an **established client-to-server TCP flow** containing:

* a path starting with `/images/`
* the strings `_2F` and `_2B`
* a specific legacy Internet Explorer style user-agent
* missing `Accept`, `Cookie:`, and `Referer:` headers

The sample packet output in your text shows a GET request that matches those traits. ([docs.snort.org][3])

### Why it is inefficient

This rule searches raw/default packet data instead of using Snort 3’s HTTP sticky buffers. Snort documents that HTTP elements such as methods, URIs, headers, and request bodies are available in dedicated buffers, and rules are usually cleaner and more efficient when they target those directly. ([docs.snort.org][8])

### Key syntax used

* `flow:established,to_server;` — only client-to-server traffic in established sessions
* `content:"/images/", depth 12;` — look for `/images/` near the start
* `content:!"Accept";` — require that `Accept` is absent
* several plain `content` checks — all evaluated against the default packet buffer unless a sticky buffer is set first ([docs.snort.org][3])

### Test command

```bash
sudo snort -c /root/snorty/etc/snort/snort.lua --daq-dir /usr/local/lib/daq -R /home/htb-student/local.rules -r /home/htb-student/pcaps/ursnif.pcap -A cmg
```

---

## Example 2 — Detecting Cerber

```snort
alert udp $HOME_NET any -> $EXTERNAL_NET any (msg:"Possible Cerber Check-in"; dsize:9; content:"hi", depth 2, fast_pattern; pcre:"/^[af0-9]{7}$/R"; detection_filter:track by_src, count 1, seconds 60; sid:2816763; rev:4;)
```

### What it matches

This rule looks for **outbound UDP traffic** where:

* payload size is exactly **9 bytes**
* the first two bytes are `hi`
* the remaining bytes match **seven lowercase hex characters**
* the source exceeds the threshold set by `detection_filter` within 60 seconds

This is a good example of a small beacon/check-in style rule. ([docs.snort.org][10])

### Why it works

The rule combines three different ideas:

* **size-based filtering** with `dsize`
* **cheap prefiltering** with `content:"hi", fast_pattern`
* **format validation** with `pcre`

That keeps the regex focused and avoids applying it to every UDP payload. Snort explicitly documents `fast_pattern` as the mechanism that drives early prefiltering, and it recommends using `content` alongside `pcre` for performance. ([docs.snort.org][5])

### Key syntax used

* `dsize:9;` — exact payload length
* `content:"hi", depth 2, fast_pattern;` — match `hi` in the first two bytes and use it for fast pattern selection
* `pcre:"/^[af0-9]{7}$/R";` — validate the following seven characters
* `detection_filter:track by_src, count 1, seconds 60;` — require repeated hits from the same source over time ([docs.snort.org][10])

### Test command

```bash
sudo snort -c /root/snorty/etc/snort/snort.lua --daq-dir /usr/local/lib/daq -R /home/htb-student/local.rules -r /home/htb-student/pcaps/cerber.pcap -A cmg
```

---

## Example 3 — Detecting Patchwork

```snort
alert http $HOME_NET any -> $EXTERNAL_NET any (msg:"OISF TROJAN Targeted AutoIt FileStealer/Downloader CnC Beacon"; flow:established,to_server; http_method; content:"POST"; http_uri; content:".php?profile="; http_client_body; content:"ddager=", depth 7; http_client_body; content:"&r1=", distance 0; http_header; content:!"Accept"; http_header; content:!"Referer|3a|"; sid:10000006; rev:1;)
```

### What it matches

This rule looks for an **outbound HTTP POST** where:

* the request method is `POST`
* the URI contains `.php?profile=`
* the request body starts with `ddager=`
* the body also contains `&r1=` immediately after that part
* the headers do **not** contain `Accept`
* the headers do **not** contain `Referer:` ([docs.snort.org][8])

### Why it is better than the Ursnif example

This rule uses Snort 3’s HTTP sticky buffers properly. Instead of searching the whole payload, it matches the **method**, **URI**, **body**, and **headers** in their own parsed buffers. That is easier to read and usually more efficient. ([docs.snort.org][8])

### Key syntax used

* `alert http` — bind the rule to HTTP traffic
* `http_method; content:"POST";` — match request method
* `http_uri; content:".php?profile=";` — match normalized URI
* `http_client_body; content:"ddager=", depth 7;` — match near the start of the request body
* `http_client_body; content:"&r1=", distance 0;` — immediately after the previous body match
* `http_header; content:!"Accept";` — require that `Accept` is absent in normalized headers ([docs.snort.org][8])

### Test command

```bash
sudo snort -c /root/snorty/etc/snort/snort.lua --daq-dir /usr/local/lib/daq -R /home/htb-student/local.rules -r /home/htb-student/pcaps/patchwork.pcap -A cmg
```

---

## Example 4 — Detecting Patchwork (SSL Certificate)

```snort
alert tcp $EXTERNAL_NET any -> $HOME_NET any (msg:"Patchwork SSL Cert Detected"; flow:established,from_server; content:"|55 04 03|"; content:"|08|toigetgf", distance 1, within 9; classtype:trojan-activity; sid:10000008; rev:1;)
```

### What it matches

This rule looks for traffic from server to client where the payload contains:

* `|55 04 03|` — the ASN.1 / X.509 OID bytes for the **commonName** field
* followed very closely by the string `toigetgf`

This is a classic certificate-based detection idea: match a certificate field rather than decrypted application content. ([docs.snort.org][3])

### Why it works

The rule anchors on the **commonName OID** and then checks whether the following field value contains the suspicious common name. The sample output in your text shows the certificate bytes clearly containing `55 04 03` and `toigetgf`. ([docs.snort.org][6])

### Key syntax used

* `flow:established,from_server;` — certificate data comes from the server side
* `content:"|55 04 03|";` — anchor on the commonName field marker
* `content:"|08|toigetgf", distance 1, within 9;` — look for the string shortly after the previous match
* `classtype:trojan-activity;` — classify the event as trojan activity ([docs.snort.org][3])

### Test command

```bash
sudo snort -c /root/snorty/etc/snort/snort.lua --daq-dir /usr/local/lib/daq -R /home/htb-student/local.rules -r /home/htb-student/pcaps/patchwork.pcap -A cmg
```

---

## Practical Notes

### Good habits

* use `flow` to restrict the rule to the correct direction and session state
* prefer **HTTP sticky buffers** over raw payload matching for HTTP traffic
* combine `content` with `pcre` instead of using regex alone
* use `fast_pattern` on the most selective content match
* use `detection_filter` when repetition matters more than one single packet ([docs.snort.org][3])

### Common mistakes

* writing HTTP rules against the raw/default buffer
* using a broad `pcre` without a good `content` anchor
* forgetting `flow:established,to_server` or `from_server`
* relying only on payload size without another condition ([docs.snort.org][13])

---

## Sources

* Snort rule basics and headers. ([docs.snort.org][1])
* Snort `flow`, `content`, `fast_pattern`, `pcre`, `dsize`, and `detection_filter`. ([docs.snort.org][3])
* Snort HTTP sticky buffers: `http_method`, `http_uri`, `http_header`, `http_client_body`. ([docs.snort.org][8])
* Snort `classtype`. ([docs.snort.org][12])
* Suricata “Differences from Snort” for cross-reference on rule-writing differences. ([docs.suricata.io][14])

If you want, I can do **pfSense** next in the same wiki format.

[1]: https://docs.snort.org/rules/ "The Basics - Snort 3 Rule Writing Guide"
[2]: https://docs.snort.org/rules/headers/ "Rule Headers - Snort 3 Rule Writing Guide"
[3]: https://docs.snort.org/rules/options/non_payload/flow "flow - Snort 3 Rule Writing Guide"
[4]: https://docs.snort.org/rules/options/payload/content "content - Snort 3 Rule Writing Guide"
[5]: https://docs.snort.org/rules/options/payload/fast_pattern "fast_pattern - Snort 3 Rule Writing Guide"
[6]: https://docs.snort.org/rules/options/payload/oddw "offset, depth, distance, and within - Snort 3 Rule Writing Guide"
[7]: https://docs.snort.org/rules/options/payload/pcre "pcre - Snort 3 Rule Writing Guide"
[8]: https://docs.snort.org/rules/options/payload/http/ "HTTP Specific Options - Snort 3 Rule Writing Guide"
[9]: https://docs.snort.org/rules/options/payload/http/uri "http_uri and http_raw_uri - Snort 3 Rule Writing Guide"
[10]: https://docs.snort.org/rules/options/payload/dsize? "dsize - Snort 3 Rule Writing Guide"
[11]: https://docs.snort.org/rules/options/post/detection_filter "detection_filter - Snort 3 Rule Writing Guide"
[12]: https://docs.snort.org/rules/options/general/classtype "classtype - Snort 3 Rule Writing Guide"
[13]: https://docs.snort.org/rules/options/payload/pkt_data "pkt_data - Snort 3 Rule Writing Guide"
[14]: https://docs.suricata.io/en/latest/rules/differences-from-snort.html"8.52. Differences From Snort - Suricata Docs"
