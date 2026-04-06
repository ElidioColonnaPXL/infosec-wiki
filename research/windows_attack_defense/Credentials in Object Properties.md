# Credentials in Object Properties

---

## Description

Objects in Active Directory a `user` object can contain properties that contain information such as:

- Is the account active
- When does the account expire
- When was the last password change
- What is the name of the account
- Office location for the employee and phone number

A common practice in the past was to add the user's (or service account's) password in the `Description` or `Info` properties

---
## Attack
A simple PowerShell script can query the entire domain by looking for specific search terms/strings in the `Description` or `Info` fields:
![[scriptcreds.png]]

```powershell
PS C:\Users\bob\Downloads> SearchUserClearTextInformation -Terms "pass"

SamAccountName       : bonni
Enabled              : True
Description          : pass: Slavi123
Info                 : 
PasswordNeverExpires : True
PasswordLastSet      : 05/12/2022 15.18.05
```

---
## Prevention

We have many options to prevent this attack/misconfiguration:

- `Perform` `continuous assessments` to detect the problem of storing credentials in properties of objects.
- `Educate` employees with high privileges to avoid storing credentials in properties of objects.
- `Automate` as much as possible of the user creation process to ensure that administrators don't handle the accounts manually, reducing the risk of introducing hardcoded credentials in user objects.

## Detection

Baselining users' behavior is the best technique for detecting abuse of exposed credentials in properties of objects.
event ID `4624`/`4625` (failed and successful logon) and `4768` (Kerberos TGT requested). Below is an example of event ID `4768`:
![[4768cred.png]]

Unfortunately, the event ID `4738` generated when a user object is modified does not show the specific property that was altered, nor does it provide the new values of properties.

## Honeypot
For setting up a honeypot user, we need to ensure the followings:

- The password/credential is configured in the `Description` field, as it's the easiest to pick up by any adversary.
- The provided password is fake/incorrect.
- The account is enabled and has recent login attempts.
- While we can use a regular user or a service account, service accounts are more likely to have this exposed as administrators tend to create them manually. In contrast, automated HR systems often make employee accounts (and the employees have likely changed the password already).
- The account has the last password configured 2+ years ago (makes it more believable that the password will likely work).

