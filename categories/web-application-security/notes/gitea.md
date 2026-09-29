# Gitea

Gitea is a self-hosted Git service that provides repositories, issues, pull requests, packages, webhooks, and automation features. Its security depends on both platform configuration and the contents and history of the repositories it hosts.

## Review areas

- Require strong authentication and review administrator, organization, and repository roles.
- Disable public registration unless it is intentionally needed.
- Restrict webhook destinations, runner privileges, package publication, and automation secrets.
- Inventory public and archived repositories as well as forks, mirrors, releases, and attachments.
- Scan current files and commit history for exposed keys or tokens, then revoke exposed values rather than merely deleting a commit.
- Keep the service and its database, Git storage, and reverse proxy patched and backed up.

Audit logs, sign-in events, repository changes, and webhook activity should feed central monitoring where possible.

## Related

- [HTTP](../../network-security/notes/http.md)
