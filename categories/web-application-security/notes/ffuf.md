# FFUF

FFUF is a fast HTTP content-discovery tool that replaces the marker `FUZZ` with entries from a wordlist. It can test paths, parameter values, request bodies, or virtual-host names during an authorized review.

## Examples

```bash
ffuf -w paths.txt -u https://example.test/FUZZ -fc 404
ffuf -w names.txt -u https://example.test/ -H "Host: FUZZ.example.test" -fs 1234
ffuf -w values.txt -u "https://example.test/search?q=FUZZ" -mc 200
```

## Matching and filtering

- Match status, size, words, lines, or regular expressions with the `-m*` options.
- Filter common baseline responses with the corresponding `-f*` options.
- Use `-ac` cautiously for automatic calibration and verify what it excluded.
- Control request rate and concurrency to avoid disrupting the application.

Send several random nonexistent values first to understand wildcard pages and uniform redirects. Preserve the command, wordlist identity, timestamp, and machine-readable output. Confirm each interesting response manually; a different status or length is a discovery signal, not proof of a security issue.
