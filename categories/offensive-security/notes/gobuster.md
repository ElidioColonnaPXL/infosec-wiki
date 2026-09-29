# Gobuster

Gobuster performs wordlist-driven discovery for web paths, virtual hosts, and DNS names. Use it only for systems within an explicitly authorized scope, and select a request rate that will not disrupt the service.

## Common modes

```bash
gobuster dir -u https://example.test -w words.txt -x php,txt
gobuster vhost -u https://example.test -w subdomains.txt
gobuster dns -d example.test -w subdomains.txt
```

- `dir` requests candidate paths and can append selected file extensions.
- `vhost` changes the HTTP `Host` value to identify name-based virtual hosts.
- `dns` resolves candidate names beneath a domain.

## Interpreting results

Establish a baseline for random nonexistent names before trusting output. Uniform status codes, lengths, or redirects can indicate a wildcard response. Confirm interesting results manually, record the exact wordlist and options, and avoid treating a discovered path as evidence of a vulnerability by itself.
