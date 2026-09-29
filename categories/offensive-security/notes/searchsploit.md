# SearchSploit

SearchSploit is a local command-line interface for the Exploit Database archive. It helps correlate a product and version with published references or proof-of-concept material without making the search itself evidence that a system is vulnerable.

```bash
searchsploit apache 2.4
searchsploit --www nginx
searchsploit -x 12345
```

## Research workflow

1. Identify the product, exact version, platform, and enabled feature from more than one signal.
2. Search with the narrowest reliable terms, then inspect the full entry and its references.
3. Read prerequisites and affected-version ranges; do not rely on a title alone.
4. Review any code in an isolated environment before considering a controlled validation.
5. Document false positives, mitigations, and the source used for the conclusion.

Public proof-of-concept code can be incomplete, destructive, or modified by third parties. Treat every result as untrusted research material.
