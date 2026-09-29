# WhatWeb

WhatWeb fingerprints web technologies by examining headers, HTML, cookies, scripts, and other response traits. It can suggest a framework, content-management system, server, or library for an authorized review.

```bash
whatweb https://example.test
whatweb --aggression 1 --log-json=whatweb.json https://example.test
```

## Interpretation

Fingerprinting is probabilistic. Reverse proxies can hide origin software, custom themes can remove expected markers, and response headers can be deliberately changed. Confirm important identifications with independent evidence such as asset paths, documented behavior, or an authenticated administrative view. Start with low aggression, respect scope and rate limits, and preserve machine-readable output with the collection timestamp.

A detected product name is an inventory clue, not proof of an exploitable version or configuration.
