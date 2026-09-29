# WordPress

WordPress is a PHP-based content-management system composed of the core application, themes, plugins, uploaded media, and a database. Security reviews should consider each component as well as the web server and hosting environment.

## Security checklist

- Maintain an inventory of the core, active and inactive plugins, and themes; remove components that are no longer required.
- Apply supported updates promptly and test them in a representative environment.
- Limit administrative accounts, require strong authentication, and protect recovery paths.
- Restrict file editing and write permissions; keep configuration and backups outside the public web root.
- Review XML-RPC, REST endpoints, registration, comments, uploads, scheduled tasks, and remote publishing against actual business needs.
- Log sign-ins, administrative changes, extension installation, and unexpected file modifications.
- Back up files and the database, and regularly verify that restoration works.

Version strings and automated fingerprints are leads. Confirm exposure and configuration before drawing a security conclusion.

## Related

- [WPScan](wpscan.md)
- [HTTP](../../network-security/notes/http.md)
