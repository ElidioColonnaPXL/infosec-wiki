# WPScan

WPScan inventories observable WordPress characteristics during an authorized security review. It can identify core metadata, themes, plugins, users exposed by public interfaces, and configuration signals that deserve manual validation.

```bash
wpscan --url https://example.test/
wpscan --url https://example.test/ --enumerate vp,vt
wpscan --url https://example.test/ --format json --output wpscan.json
```

## Review workflow

1. Confirm that the site is WordPress and record the collection time and scope.
2. Begin with passive techniques, then enable more active enumeration only when authorized.
3. Compare detected component versions with vendor advisories and supported release information.
4. Verify findings manually because themes, proxies, caching, and hidden version strings can produce incomplete or misleading results.
5. Protect reports: discovered users, paths, and component data may be sensitive.

An API token can enrich vulnerability references, but a scanner match is not by itself evidence that a weakness is reachable. Consider whether the affected component is enabled, exposed, configured in the vulnerable mode, and protected by compensating controls.

## Related

- [WordPress](wordpress.md)
