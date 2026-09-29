# Phishing Investigation Example


## Triage sequence

1. Review the highest-severity alert first, but do not equate severity with truth.
2. Validate sender domain, display name, reply-to, authentication results and message context.
3. Expand shortened links safely and compare visible versus actual destinations.
4. Search proxy, DNS, firewall and endpoint telemetry for user interaction.
5. Correlate shared URLs, domains, recipients, source hosts and timestamps.
6. Classify, document confidence and escalate when remediation is required.

## Strong phishing indicators

- Typosquatted or unrelated sender domain.
- Urgency, fear or package/account lures.
- URL shorteners or deceptive links.
- Credential-harvesting login pages.
- Follow-on DNS, web or firewall activity from a recipient host.

## False-positive considerations

An external link alone is not sufficient. Validate whether sender, domain, subject, business process and destination are internally consistent.

## Cross-source correlation

```text
Email alert → URL/domain → DNS/proxy/firewall event
→ endpoint process/browser evidence → account sign-in activity
```

## Related

- Incident Handling Process
- Log Sources and Splunk
- SMTP
- [DMARC](../../network-security/notes/dmarc.md)
- Splunk

## Source
