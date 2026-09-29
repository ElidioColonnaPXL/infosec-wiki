# Cyber Kill Chain

**Definition & Purpose:**
The Cyber Kill Chain outlines the stages of a cyberattack. Understanding it helps defenders identify, detect, and stop attackers early in their lifecycle. The kill chain is not strictly linear—attackers may loop through stages repeatedly to deepen access.


### Stages of the Kill Chain:

1. **Reconnaissance:**

    - Attacker gathers info about the target (e.g., through open-source intelligence, scanning).

    - Can be passive (e.g., LinkedIn, job ads) or active (e.g., port scans, probing).

2. **Weaponization:**

    - Crafting of malware or exploit, often tailored to bypass defenses.

    - Aims to gain remote access and persistence.

3. **Delivery:**

    - Transmitting the payload to the target.

    - Common methods: phishing emails, malicious websites, USB drops, or voice phishing (vishing).

4. **Exploitation:**

    - Triggering the payload to execute malicious code.

    - May leverage software vulnerabilities or social engineering.

5. **Installation:**

    - Malware is installed to maintain presence.

    - Common tools: droppers, backdoors, rootkits.

6. **Command and Control (C2):**

    - Establishing remote control over compromised systems.

    - Often modular and redundant for resilience.

7. **Actions on Objectives:**

    - Execution of the attack's goal (e.g., data theft, ransomware deployment, privilege escalation).


**Key Insight:**
Disrupting the attack as early as possible in the chain reduces potential damage. Detection and prevention strategies should focus on early stages like Recon, Delivery, and Exploitation.

**Reference Use:**
This model is a strategic framework used in incident response, threat hunting, and red/blue team operations.

Incident Handling Process
Penetration Testing Process
