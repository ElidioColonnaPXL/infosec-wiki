# Infosec Wiki

This repository documents hands-on work across multiple domains including **network forensics, log analysis, web application behavior, and incident investigation**.
The goal is to build a structured understanding of how attacks occur, how they can be identified, and how they can be mitigated in real environments.

![infosec-wiki](investigations/network_traffic_analysis/images/infosecwiki.png)

---

## Scope

This project focuses on:

* Security investigations based on realistic scenarios
* Analysis of network traffic, logs, and system behavior
* Identification of attacker techniques and patterns
* Detection opportunities and defensive strategies
* Practical lab setups and experiments

---

## Structure

```bash
.
├── investigations/   # Incident-style analyses (core content)
├── detections/       # Detection logic, queries, and rules
├── lab/              # Homelab setup and experiments
├── notes/            # Supporting technical concepts
├── walkthroughs/     # Selected technical exercises (supporting)
```

---

## Investigations

Each investigation is structured as a concise report:

* Executive summary
* Timeline of events
* Evidence and analysis
* Attack classification (MITRE ATT&CK where applicable)
* Indicators of compromise (IOCs)
* Detection opportunities
* Mitigation strategies

The emphasis is on **understanding behavior and identifying signals**, rather than simply reproducing steps.

---

## Detections

This section contains practical detection logic such as:

* Query examples (e.g. log filtering and correlation)
* Detection rules and patterns
* Basic threat hunting concepts

The focus is on translating observed behavior into **actionable monitoring strategies**.

---

## Lab

The lab environment is used to simulate scenarios and validate detection approaches.

Examples include:

* Log generation and collection
* Simulated attack activity
* Analysis of system and network artifacts

---

## Approach

This repository is built around a simple principle:

> Understanding an attack is not enough — being able to detect and explain it is essential.

Content is therefore written with emphasis on:

* Clarity over completeness
* Analysis over tooling
* Practical relevance over theory

---

## Notes

Supporting material used throughout investigations:

* Networking fundamentals
* Authentication mechanisms
* Common attack patterns
* System and log behavior

---

## Status

This is an ongoing project with no defined endpoint.
Content is continuously added, refined, and reorganized as new scenarios and insights are explored.
