[Hashcat](https://hashcat.net/hashcat/) is a **password cracking tool** used to recover plaintext passwords from hashes.
Cracking Passwords with Hashcat
Supports:

- MD5, SHA1, SHA256, SHA512

- NTLM, bcrypt, Argon2

- WPA/WPA2, Cisco, Linux shadow, etc.

---

#  Basic syntax

```bash
hashcat -m <mode> -a <attack_mode> <hash_file> <wordlist>
```

|Parameter|Meaning|
|---|---|
|-m|Hash type (hash mode)|
|-a|Attack mode|
|hash_file|File containing hashes|
|wordlist|Password list|

---

#  Common attack modes

|Mode|Name|Description|
|---|---|---|
|0|Dictionary|Try passwords from wordlist|
|3|Brute force|Try all combinations|
|1|Combination|Combine two wordlists|
|6|Hybrid wordlist + mask|Append characters|
|7|Hybrid mask + wordlist|Prepend characters|

Example:

```bash
hashcat -m 0 -a 0 hashes.txt rockyou.txt
```

---

# Common hash modes

|Hash type|Mode|
|---|---|
|MD5|0|
|SHA1|100|
|SHA256|1400|
|SHA512|1700|
|NTLM|1000|
|bcrypt|3200|
|Cisco-ASA MD5|2410|
|Linux SHA512|1800|

---

# Identify hash mode

Use hashid:

```bash
hashid hash.txt
```

Or check:

```bash
hashcat --help
```

---

# Show cracked passwords

```bash
hashcat -m <mode> hash.txt rockyou.txt --show
```

---

# Example full workflow

```bash
hashid hash.txt
hashcat -m 1000 -a 0 hash.txt rockyou.txt
hashcat -m 1000 hash.txt --show
```

---

# Important files

|File|Purpose|
|---|---|
|hashes.txt|Contains hashes|
|rockyou.txt|Common wordlist|

Location:

```bash
/usr/share/wordlists/rockyou.txt
```

---

#  Performance tips

- Use GPU if available

- Use correct hash mode

- Use good wordlists

- Use rules for mutations


Example:

```bash
hashcat -m 1000 -a 0 hash.txt rockyou.txt -r rules/best64.rule
```

---


- -m = hash type

- -a 0 = dictionary attack

- rockyou.txt = common wordlist

- hashcat --show = display cracked passwords

- Correct hash mode is critical
