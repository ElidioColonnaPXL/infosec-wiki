![infosec-wiki](research/network_traffic_analysis/images/infosecwikilogo2.png)

---

A blue-team focused knowledge base for investigations, detections, and lab-driven security analysis.

This repository documents hands-on work across network traffic analysis, detection engineering, security investigations, lab scenarios, and selected technical walkthroughs. The main goal is not simply to collect notes, but to build a structured body of work that focuses on understanding attacker behavior, validating findings with evidence, and improving defensive visibility.

Rather than treating security as isolated tools or one-off exercises, this project is built around a practical analyst mindset: investigate, validate, detect, and explain.

---

## Featured Content

### Featured Investigations
- **Network traffic investigations** — analysis of suspicious or abnormal activity using packet captures, protocol behavior, filtering, and evidence-based conclusions.
- **Incident-style case reports** — structured investigations that reconstruct what happened, how it was identified, and what defensive lessons can be taken from it.
- **Sherlock-based reports** — challenge material rewritten as professional investigation reports rather than flag-oriented writeups.

### Featured Detections
- **Detection notes and logic** — practical detection ideas derived from observed attacker behavior, mapped where relevant to MITRE ATT&CK.
- **Query and rule development** — SIEM-style analysis, rule tuning, and defensive logic intended to improve visibility and reduce analyst guesswork.
- **Detection opportunities from investigations** — cases where investigative findings are translated into alerting or hunting ideas.

### Featured Lab Work
- **Homelab security analysis** — lab-driven validation of detections, logging, telemetry collection, and attack simulation.
- **SIEM-focused experimentation** — testing alerts, reviewing events, and improving understanding of defensive workflows.
- **Hands-on blue-team workflows** — scenarios designed to support investigation, triage, and defensive analysis.

---

## Scope

The repository is centered around defensive and analytical security work, including:

- security investigations
- network traffic analysis
- detections and detection logic
- homelab-driven testing and validation
- selected walkthroughs with defensive value
- technical notes tied to practical analyst workflows
- scripts and small utilities that support analysis

The emphasis is on material that helps explain **what happened**, **how it can be identified**, and **how similar activity can be detected in the future**.

---

## Repository Layout

```text
infosec-wiki/
├── detections/         # Detection notes, ideas, rules, and related logic
├── investigations/     # Incident-style writeups and structured case reports
├── lab/                # Homelab notes, setups, testing, and validation
├── notes/              # Supporting technical notes and reference material
├── scripts/            # Small utilities and helper scripts
├── walkthroughs/       # Selected walkthroughs with practical security value
└── images/             # Screenshots and supporting visuals
````

---

## Investigation Method

Each investigation is documented with emphasis on:

* what happened
* how it was identified
* which evidence supports the conclusion
* what the likely impact or significance is
* how similar activity could be detected or investigated in the future

The goal is to keep writeups structured, reproducible, and useful from a defensive perspective.

---

## Detections

The **detections/** section is intended for defensive logic and analysis that can support blue-team workflows.

This includes:

* behavior-based detection ideas
* analyst notes tied to observed techniques
* rule or query development
* ATT&CK-aligned detection thinking
* opportunities discovered during investigations or lab work

This section is not meant to be a rule dump. The focus is on documenting the reasoning behind detections and the behaviors they are meant to identify.

---

## Investigations

The **investigations/** section is the core of the repository.

These entries are written as structured analyst reports rather than simple challenge solutions. The aim is to reconstruct events, validate conclusions with evidence, and explain the analysis process in a clear and professional way.

Typical investigation content includes:

* concise incident summary
* evidence reviewed
* analysis process and reasoning
* timeline or sequence of activity
* findings and conclusions
* detection opportunities
* defensive recommendations where relevant

---

## Lab Work

The **lab/** section documents practical testing in controlled environments.

This includes:

* SIEM-related experiments
* telemetry collection and review
* validation of suspicious activity
* attack simulation for defensive analysis
* logging and alerting exercises

The lab is used to move beyond theory and test how security events actually appear in data.

---

## Walkthroughs

The **walkthroughs/** section contains selected technical walkthroughs that still offer practical value for defensive understanding.

These are included when they contribute to areas such as:

* enumeration awareness
* attack-path understanding
* exposure identification
* investigation or detection ideas
* broader blue-team context

Walkthroughs are supporting material, while investigations and detections remain the main focus of the repository.

---

## Tooling and Techniques

This repository regularly involves tooling and concepts such as:

* Wireshark / tshark
* Sigma
* SIEM-style query logic
* Windows event analysis
* packet capture analysis
* Python scripting
* MITRE ATT&CK mapping
* log review and evidence correlation

The exact tooling may evolve, but the focus remains on practical analysis and defensive understanding.

---

## Notes

This project combines:

* independent research
* hands-on lab work
* structured learning
* investigation-driven documentation
* defensive analysis of real or simulated scenarios

Some material is based on training platforms, practice labs, or challenge environments, but the objective is always to extract practical analyst value rather than just complete exercises.

---

## Status

This is an ongoing project with no fixed endpoint.

It is continuously expanded with new investigations, detections, lab material, and supporting notes as skills develop and new scenarios are explored.

Feedback and suggestions are welcome.


