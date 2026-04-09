# Suricata Rules

## Overview

A Suricata rule tells the engine **what traffic to inspect**, **what pattern to look for**, and **what action to take** when the rule matches. In Suricata terms, a rule is made of three parts: **action**, **header**, and **rule options**. ([Suricata Documentation][1])

## Basic Syntax

```suricata
action protocol src_ip src_port -> dst_ip dst_port (options;)
```

Example:

```suricata
alert http $HOME_NET any -> $EXTERNAL_NET any (msg:"Example"; content:"GET"; http_method; sid:1000001; rev:1;)
```

## Rule Anatomy

### 1. Action

Defines what Suricata should do when the rule matches.

Common actions:

* `alert` — generate an alert
* `log` — log the traffic
* `pass` — ignore matching traffic
* `drop` — block matching traffic in IPS mode
* `reject` — actively reject matching traffic

Suricata documents these as standard rule actions in the rule format section. ([Suricata Documentation][1])

### 2. Header

Defines:

* protocol
* source IP / port
* direction
* destination IP / port

Examples:

```suricata
alert tcp $HOME_NET any -> $EXTERNAL_NET 443
alert http $EXTERNAL_NET any -> $HOME_NET any
alert tcp any any <> any any
```

The header controls **where** the rule applies and in **which direction** traffic must flow. ([Suricata Documentation][1])

### 3. Rule Options

Rule options define the actual detection logic.

Common options:

* `msg`
* `flow`
* `content`
* `pcre`
* `nocase`
* `offset`
* `depth`
* `distance`
* `within`
* `dsize`
* `detection_filter`
* `sid`
* `rev`
* `reference`

These are the core building blocks for most real Suricata signatures. ([Suricata Documentation][2])

---

## Important Syntax Keywords

### `flow`

Used to define traffic direction and connection state.

Examples:

```suricata
flow:to_server;
flow:from_server;
flow:established,to_server;
```

This is one of the most important keywords for reducing noise and matching only the correct side of a session. ([Suricata Documentation][3])

### `content`

Matches a literal string or byte pattern in a packet or sticky buffer.

Examples:

```suricata
content:"GET";
content:"|0d 0a|";
```

### `pcre`

Uses a regular expression for more flexible matching.

Example:

```suricata
pcre:"/admin\/login\.php/i";
```

PCRE is powerful, but Suricata recommends using it carefully because regular expressions are more expensive than simple `content` matches. ([Suricata Documentation][4])

### HTTP sticky buffers

Suricata can inspect specific HTTP fields instead of searching the full payload.

Common examples:

* `http_method`
* `http_uri`
* `http_cookie`
* `http_user_agent`
* `http_client_body`

This is both cleaner and more efficient than matching the whole packet. ([Suricata Documentation][5])

### `offset`, `depth`, `distance`, `within`

These control **where** Suricata searches for content.

* `offset` — where to start
* `depth` — how far to search
* `distance` — how far after the previous match to begin
* `within` — search window size after the previous match

These are essential when writing precise signatures. ([Suricata Documentation][6])

### `dsize`

Matches payload size.

Example:

```suricata
dsize:312;
```

Useful for analytics-style rules, but it is more brittle than content-based detection because size can change across versions or configurations. Also, packet offloading can affect `dsize` behavior in live capture. ([Suricata Documentation][7])

### `detection_filter`

Adds threshold logic.

Example:

```suricata
detection_filter: track by_src, count 4, seconds 10;
```

This is useful when one packet alone is weak evidence, but repeated matches in a short window are more suspicious. ([Suricata Documentation][8])

---

## Rule Development Approaches

### Signature-based

Detects **known strings, byte patterns, paths, headers, cookies, or certificate traits**.

### Behavior / analytics-based

Detects **repeated size patterns, timing patterns, or frequency-based behavior**.

### Encrypted traffic detection

Detects malicious traffic using **TLS metadata**, **certificate details**, or **JA3 hashes**, even when payload content is encrypted. Suricata supports both TLS-specific keywords and JA3/JA4 keywords for this purpose. ([Suricata Documentation][9])

---

# Suricata Rule Development Examples

## Example 1 — Detecting PowerShell Empire

```suricata
alert http $HOME_NET any -> $EXTERNAL_NET any (msg:"ET MALWARE Possible PowerShell Empire Activity Outbound"; flow:established,to_server; content:"GET"; http_method; content:"/"; http_uri; depth:1; pcre:"/^(?:login\/process|admin\/get|news)\.php$/RU"; content:"session="; http_cookie; pcre:"/^(?:[A-Z0-9+/]{4})*(?:[A-Z0-9+/]{2}==|[A-Z0-9+/]{3}=|[A-Z0-9+/]{4})$/CRi"; content:"Mozilla|2f|5.0|20 28|Windows|20|NT|20|6.1"; http_user_agent; http_start; content:".php|20|HTTP|2f|1.1|0d 0a|Cookie|3a 20|session="; fast_pattern; http_header_names; content:!"Referer"; content:!"Cache"; content:!"Accept"; sid:2027512; rev:1;)
```

### What it looks for

This rule looks for an **outbound HTTP GET request** from `$HOME_NET` to `$EXTERNAL_NET` with all of the following:

* request to one of these paths:

  * `/login/process.php`
  * `/admin/get.php`
  * `/news.php`
* a cookie containing `session=`
* cookie value that looks like **Base64**
* a specific Windows-style user agent
* missing `Referer`, `Cache`, and `Accept` headers

### Why it works

Empire’s archived agent code shows a default HTTP profile containing the URI set `/admin/get.php,/news.php,/login/process.php` and a default user-agent beginning with `Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko`. External analysis also notes Empire’s use of Base64-encoded cookie data in HTTP communications. ([GitHub][10])

### Key syntax

* `flow:established,to_server;` — only inspect established client-to-server traffic
* `http_method` — match the HTTP method buffer
* `http_uri` — match the URI only
* `http_cookie` — inspect cookie content
* `http_user_agent` — inspect User-Agent only
* `pcre` — match allowed PHP endpoints and Base64-like cookie format
* `fast_pattern` — optimize prefiltering
* `content:!"..."` — require that a header is absent

The HTTP buffer keywords used here are documented by Suricata as sticky buffers that allow efficient field-specific matching. ([Suricata Documentation][5])

### Why this rule is stronger than a simple string match

This is a **multi-condition signature**. It does not rely on one weak IOC. It combines:

* path pattern
* cookie name
* cookie format
* user-agent pattern
* header absence

That reduces false positives compared with a single `content` match.

### Test command

```bash
sudo suricata -r /home/htb-student/pcaps/psempire.pcap -l . -k none
cat fast.log
```

### Sources

* Empire agent profile and defaults. ([GitHub][10])
* Suricata HTTP keyword documentation. ([Suricata Documentation][5])
* Background on JA3/Base64-style Empire HTTP behavior. ([Salesforce Engineering Blog][11])

---

## Example 2 — Detecting Covenant

```suricata
alert tcp any any -> $HOME_NET any (msg:"detected by body"; content:"<title>Hello World!</title>"; detection_filter: track by_src, count 4 , seconds 10; priority:1; sid:3000011;)
```

### What it looks for

This rule alerts when traffic to `$HOME_NET` contains:

```html
<title>Hello World!</title>
```

and that happens **4 times within 10 seconds** from the same source.

### Why it works

Covenant’s default HTTP profile contains `Hello World!` in both the GET and POST HTML responses. That makes the title a recognizable signature for default or near-default Covenant traffic. ([GitHub][12])

### Key syntax

* `content:"<title>Hello World!</title>";` — literal signature match
* `detection_filter: track by_src, count 4, seconds 10;` — only alert after repeated hits from the same source
* `priority:1;` — assign higher alert priority

Suricata documents `detection_filter` as threshold logic that alerts after a defined count within a time window. ([Suricata Documentation][8])

### Strengths

* simple
* easy to understand
* works well when the default profile is unchanged

### Weaknesses

* weak against profile customization
* the string is generic enough to create false positives
* inefficient because it searches normal TCP payload instead of a more precise HTTP buffer

### Test command

```bash
sudo suricata -r /home/htb-student/pcaps/covenant.pcap -l . -k none
cat fast.log
```

### Sources

* Covenant default HTTP profile. ([GitHub][12])
* Suricata thresholding / detection filter docs. ([Suricata Documentation][8])

---

## Example 3 — Detecting Covenant with Analytics

```suricata
alert tcp $HOME_NET any -> any any (msg:"detected by size and counter"; dsize:312; detection_filter: track by_src, count 3 , seconds 10; priority:1; sid:3000001;)
```

### What it looks for

This rule alerts when a host in `$HOME_NET` sends **three TCP payloads of exactly 312 bytes within 10 seconds**.

### Why it works

This is not a classic signature rule. It is an **analytics-style rule**. The assumption is that the Covenant traffic in the sample repeatedly produces a payload size of 312 bytes, so repeated matches become suspicious.

### Key syntax

* `dsize:312;` — exact payload size match
* `detection_filter: track by_src, count 3, seconds 10;` — only alert on repetition
* `priority:1;` — higher priority

Suricata treats `dsize` as a payload-size keyword and documents `detection_filter` as a thresholding primitive. It also notes that packet offloading can interfere with `dsize` behavior in live capture environments. ([Suricata Documentation][7])

### Strengths

* can catch malware traffic even if visible strings change
* useful when beacon traffic has stable size patterns

### Weaknesses

* fragile if the beacon size changes
* can false positive on unrelated traffic with the same payload size
* should be combined with other rules, not used alone

### Test command

```bash
sudo suricata -r /home/htb-student/pcaps/covenant.pcap -l . -k none
cat fast.log
```

### Sources

* Suricata payload keyword docs. ([Suricata Documentation][7])
* Suricata thresholding docs. ([Suricata Documentation][8])

---

## Example 4 — Detecting Sliver

```suricata
alert tcp any any -> any any (msg:"Sliver C2 Implant Detected"; content:"POST"; pcre:"/\/(php|api|upload|actions|rest|v1|oauth2callback|authenticate|oauth2|oauth|auth|database|db|namespaces)(.*?)((login|signin|api|samples|rpc|index|admin|register|sign-up)\.php)\?[a-z_]{1,2}=[a-z0-9]{1,10}/i"; sid:1000007; rev:1;)
```

### What it looks for

This rule looks for a `POST` request whose URI resembles a **generated Sliver-style path**, including:

* suspicious application-like directory names
* PHP file names such as `login.php`, `admin.php`, `register.php`, `sign-up.php`
* a short query parameter name and short alphanumeric value

### Why it works

Sliver’s HTTP(S) C2 is designed to be **procedurally generated** and customizable. Bishop Fox’s documentation explains that HTTP C2 traffic can be modified extensively, while the codebase shows default path segment generators, file/extension generators, and default cookie name pools. That means defenders often detect Sliver through **pattern families** rather than one exact URI. ([GitHub][13])

### Key syntax

* `content:"POST";` — narrow to POST traffic first
* `pcre:"/.../i";` — heavy lifting is done by regex
* no HTTP sticky buffer is used here, so this is broader and less precise than it could be

### Strengths

* good for catching a family of generated URI patterns
* useful when exact static IOCs do not exist

### Weaknesses

* heuristic, not deterministic
* more false positives than buffer-aware rules
* expensive because it relies heavily on regex
* best treated as a **community hunting rule**, not a high-confidence standalone signature

### Test command

```bash
sudo suricata -r /home/htb-student/pcaps/sliver.pcap -l . -k none
cat fast.log
```

### Sources

* Sliver HTTP(S) C2 documentation. ([GitHub][13])
* Sliver HTTP C2 config / defaults. ([GitHub][14])

---

## Example 4.1 — Detecting Sliver by Cookie Pattern

```suricata
alert tcp any any -> any any (msg:"Sliver C2 Implant Detected - Cookie"; content:"Set-Cookie"; pcre:"/(PHPSESSID|SID|SSID|APISID|csrf-state|AWSALBCORS)\=[a-z0-9]{32}\;/"; sid:1000003; rev:1;)
```

### What it looks for

This rule looks for a `Set-Cookie` header where the cookie name is one of:

* `PHPSESSID`
* `SID`
* `SSID`
* `APISID`
* `csrf-state`
* `AWSALBCORS`

with a 32-character lowercase alphanumeric value.

### Why it works

Sliver’s default HTTP C2 configuration code includes those cookie names in its generated cookie pool, so a rule matching those names and value structure can catch default or lightly modified profiles. ([GitHub][14])

### Key syntax

* `content:"Set-Cookie";` — anchor on HTTP response cookie setting
* `pcre` — match the cookie-name list and fixed-length value format

### Weaknesses

Like the previous Sliver rule, this is a **heuristic**. Those cookie names are not unique to malware, so this rule should be paired with other detections.

### Sources

* Sliver default cookie names in `http-c2.go`. ([GitHub][14])

---

## Example 5 — Detecting Dridex over TLS

```suricata
alert tls $EXTERNAL_NET any -> $HOME_NET any (msg:"ET MALWARE ABUSE.CH SSL Blacklist Malicious SSL certificate detected (Dridex)"; flow:established,from_server; content:"|16|"; content:"|0b|"; within:8; byte_test:3,<,1200,0,relative; content:"|03 02 01 02 02 09 00|"; fast_pattern; content:"|30 09 06 03 55 04 06 13 02|"; distance:0; pcre:"/^[A-Z]{2}/R"; content:"|55 04 07|"; distance:0; content:"|55 04 0a|"; distance:0; pcre:"/^.{2}[A-Z][a-z]{3,}\s(?:[A-Z][a-z]{3,}\s)?(?:[A-Z](?:[A-Za-z]{0,4}?[A-Z]|(?:\.[A-Za-z]){1,3})|[A-Z]?[a-z]+|[a-z](?:\.[A-Za-z]){1,3})\.?[01]/Rs"; content:"|55 04 03|"; distance:0; byte_test:1,>,13,1,relative; content:!"www."; distance:2; within:4; pcre:"/^.{2}(?P<CN>(?:(?:\d?[A-Z]?|[A-Z]?\d?)(?:[a-z]{3,20}|[a-z]{3,6}[0-9_][a-z]{3,6})\.){0,2}?(?:\d?[A-Z]?|[A-Z]?\d?)[a-z]{3,}(?:[0-9_-][a-z]{3,})?\.(?!com|org|net|tv)[a-z]{2,9})[01].*?(?P=CN)[01]/Rs"; content:!"|2a 86 48 86 f7 0d 01 09 01|"; content:!"GoDaddy"; sid:2023476; rev:5;)
```

### What it looks for

This rule inspects **TLS certificate data** from server to client and looks for:

* TLS handshake / certificate byte markers
* ASN.1 / X.509 subject-field patterns
* subject structure anomalies seen in known Dridex certificates
* exclusions such as `www.` and `GoDaddy`

### Why it works

Suricata supports TLS-focused keywording and payload inspection in handshake metadata, while abuse.ch’s SSLBL tracks malicious certificates and publishes Suricata-oriented SSL blacklists and rulesets. abuse.ch has multiple certificate entries tied to Dridex C2 infrastructure. ([Suricata Documentation][9])

### Key syntax

* `alert tls` — inspect TLS traffic specifically
* `flow:established,from_server;` — certificate comes from the server side
* raw `content:"|...|"` matches — look for ASN.1 / TLS byte patterns
* `byte_test` — compare extracted byte values
* `pcre` — validate structure of subject fields
* `fast_pattern` — accelerate candidate selection

Suricata documents both TLS-specific matching and `byte_test` behavior in its rules documentation. ([Suricata Documentation][9])

### What matters most here

You do **not** need to read every byte test manually. The important point is that this rule detects malware through **certificate structure and metadata**, not decrypted HTTP content.

### Test command

```bash
sudo suricata -r /home/htb-student/pcaps/dridex.pcap -l . -k none
cat fast.log
```

### Sources

* Suricata TLS keyword docs. ([Suricata Documentation][9])
* Suricata `byte_test` docs. ([Suricata Documentation][15])
* abuse.ch SSLBL / Dridex certificate references. ([SSL Blacklist][16])

---

## Example 6 — Detecting Sliver over TLS with JA3

```suricata
alert tls any any -> any any (msg:"Sliver C2 SSL"; ja3.hash; content:"473cd7cb9faa642487833865d516e578"; sid:1002; rev:1;)
```

### What it looks for

This rule matches any TLS client whose **JA3 hash** is:

```text
473cd7cb9faa642487833865d516e578
```

### Why it works

JA3 fingerprints a TLS client by hashing fields from the ClientHello. Salesforce introduced JA3 as a way to identify clients based on handshake structure, and Suricata supports matching JA3 values with `ja3.hash`. In the provided sample, the `ja3` tool repeatedly produces the same digest for the Sliver client traffic. ([Salesforce Engineering Blog][11])

### Key syntax

* `alert tls` — inspect TLS sessions
* `ja3.hash;` — switch to the JA3 buffer
* `content:"473cd7cb9faa642487833865d516e578";` — match the exact JA3 digest

### Strengths

* works on encrypted traffic
* easy to write
* efficient compared with large regex-based rules

### Weaknesses

* JA3 is not globally unique
* malware can change TLS libraries or settings
* should be combined with other network or host detections

### Test command

```bash
ja3 -a --json /home/htb-student/pcaps/sliverenc.pcap
sudo suricata -r /home/htb-student/pcaps/sliverenc.pcap -l . -k none
cat fast.log
```

### Sources

* JA3 background. ([Salesforce Engineering Blog][11])
* Suricata JA3 keyword docs. ([Suricata Documentation][17])

---

# Sources

## Core Suricata documentation

* Rules format and rule structure. ([Suricata Documentation][1])
* HTTP sticky buffers. ([Suricata Documentation][5])
* Flow keywords. ([Suricata Documentation][3])
* Payload keywords / offset / depth / PCRE / byte_test / dsize. ([Suricata Documentation][6])
* Thresholding / detection_filter. ([Suricata Documentation][8])
* TLS keywords. ([Suricata Documentation][9])
* JA3 keywords. ([Suricata Documentation][17])

## Framework / threat references

* Empire agent defaults. ([GitHub][10])
* Covenant default HTTP profile. ([GitHub][12])
* Sliver HTTP C2 and defaults. ([GitHub][13])
* abuse.ch SSLBL / Dridex certificate tracking. ([SSL Blacklist][16])
* JA3 original reference. ([Salesforce Engineering Blog][11])


[1]: https://docs.suricata.io/en/latest/rules/intro.html "8.1. Rules Format — Suricata 9.0.0-dev documentation"
[2]: https://docs.suricata.io/en/latest/rules/index.html "8. Suricata Rules — Suricata 9.0.0-dev documentation"
[3]: https://docs.suricata.io/en/latest/rules/flow-keywords.html "8.13. Flow Keywords — Suricata 9.0.0-dev documentation"
[4]: https://docs.suricata.io/en/suricata-6.0.20/rules/payload-keywords.html "7.7. Payload Keywords — Suricata 6.0.20 documentation"
[5]: https://docs.suricata.io/en/latest/rules/http-keywords.html "8.15. HTTP Keywords — Suricata 9.0.0-dev documentation"
[6]: https://docs.suricata.io/en/latest/rules/payload-keywords.html "8.9. Payload Keywords — Suricata 9.0.0-dev documentation"
[7]: https://docs.suricata.io/en/suricata-8.0.0/rules/differences-from-snort.html "8.50. Differences From Snort — Suricata 8.0.0 documentation"
[8]: https://docs.suricata.io/en/latest/rules/thresholding.html "8.46. Thresholding Keywords - Suricata Docs"
[9]: https://docs.suricata.io/en/latest/rules/tls-keywords.html "8.19. SSL/TLS Keywords — Suricata 9.0.0-dev documentation"
[10]: https://github.com/EmpireProject/Empire/blob/master/data/agent/agent.ps1 "Empire/data/agent/agent.ps1 at master · EmpireProject/Empire · GitHub"
[11]: https://engineering.salesforce.com/open-sourcing-ja3-92c9e53c3c41/ "Open Sourcing JA3"
[12]: https://github.com/cobbr/Covenant/blob/master/Covenant/Data/Profiles/DefaultHttpProfile.yaml "Covenant/Covenant/Data/Profiles/DefaultHttpProfile.yaml at master · cobbr/Covenant · GitHub"
[13]: https://github.com/BishopFox/sliver/wiki/HTTP%28S%29-C2/be65c9de83bcb779bb66cb77742d215af8be1d1e "HTTP(S) C2 · BishopFox/sliver Wiki · GitHub"
[14]: https://github.com/BishopFox/sliver/blob/master/server/configs/http-c2.go "sliver/server/configs/http-c2.go at master · BishopFox/sliver · GitHub"
[15]: https://docs.suricata.io/en/suricata-7.0.11/rules/payload-keywords.html "8.7. Payload Keywords — Suricata 7.0.11 documentation"
[16]: https://sslbl.abuse.ch/blacklist/ "SSLBL | Blacklist - Abuse.ch"
[17]: https://docs.suricata.io/en/latest/rules/ja-keywords.html "8.21. JA3/JA4 Keywords — Suricata 9.0.0-dev documentation"



