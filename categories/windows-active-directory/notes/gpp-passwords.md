# Group Policy Preferences Password Exposure

Older Group Policy Preferences could place encrypted password values in XML files distributed through SYSVOL. The published decryption key meant any authenticated principal able to read those files could recover the value. Microsoft removed the ability to create new affected preference items, but the update did not delete values already present.

## Review

Inventory SYSVOL for preference XML that contains `cpassword` or other secret material, and review historical copies and backups according to retention policy. Determine which accounts and services used each value before changing or removing it.

## Remediation

1. Treat every discovered value as exposed and rotate the associated secret.
2. Replace the preference with a supported management mechanism that does not distribute reusable secrets.
3. Remove the legacy value after dependent systems are updated.
4. Review sign-ins and privilege use for the affected account during the possible exposure window.
5. Add recurring checks so restored or copied policies do not reintroduce the value.

## Reference

- [Microsoft Security Bulletin MS14-025](https://learn.microsoft.com/en-us/security-updates/securitybulletins/2014/ms14-025)
