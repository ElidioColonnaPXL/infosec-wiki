# HTTP

HTTP is an application-layer request/response protocol used to transfer web resources and API data.

## Defaults

| Item | Value |
|---|---|
| Default port | TCP/80 |
| Secure variant | [HTTPS](https.md) |
| Common methods | `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, `HEAD`, `OPTIONS` |
| Common evidence | host, URI, method, status, headers, user agent, referrer and body metadata |

## Security relevance

- Cleartext HTTP exposes content and credentials to observers.
- Host and URI patterns are useful for C2 and malware-delivery detection.
- Proxies, web servers, [Zeek](../../ids-ips-detection-engineering/notes/zeek.md) and [Suricata](../../ids-ips-detection-engineering/notes/suricata.md) generate valuable HTTP telemetry.

## Related

- [HTTPS](https.md)
- DNS
- Introduction to Network Traffic Analysis

## Detection References

- HTTP beaconing detection
- HTTP exfiltration detection
