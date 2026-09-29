# Hashing

Cracking Passwords with Hashcat


Hashing converts plaintext into a **fixed-length hash** using a one-way function.

- Cannot be reversed

- Same input → same hash

- Used for integrity and password storage


---

## Purpose

|Use case|Example|
|---|---|
|Password storage|Argon2, BCrypt|
|File integrity|MD5, SHA256|
|Message integrity|HMAC|

---

## Common password hashing algorithms

|Algorithm|Security|Notes|
|---|---|---|
|SHA-512|Medium|Fast, vulnerable to rainbow tables|
|BCrypt|High|Slow, secure|
|Argon2|Very High|Modern standard, memory-hard|
|PBKDF2|High|Adjustable cost|

---

## Salt

**Definition:** Random data added before hashing.

```text
hash = Hash(password + salt)
```

**Purpose:**

- Prevent rainbow table attacks

- Makes identical passwords produce different hashes
