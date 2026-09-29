# Sigma

> **Note:**
> Vendor-agnostic detection-rule format for describing suspicious log events and translating the logic into SIEM-specific queries.

## Structure

```yaml
title: Suspicious LSASS Access
status: test
logsource:
  product: windows
  category: process_access
detection:
  selection:
    TargetImage|endswith: '\\lsass.exe'
  condition: selection
level: high
```

## Workflow

1. Define the required log source and fields.
2. Express the smallest behaviorally meaningful selection.
3. Add filters for understood benign activity.
4. Validate against representative logs.
5. Translate for the target SIEM.
6. Record false positives, ATT&CK mapping and test evidence.

## Related

- [YARA](yara.md)
- Chainsaw
- Splunk
- KQL
- YARA and Sigma for SOC Analysts
