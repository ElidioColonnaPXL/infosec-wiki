# Encryption

## Definition

Encryption converts plaintext into ciphertext using a key and is **reversible**.

```text
Plaintext → Encrypt → Ciphertext → Decrypt → Plaintext
```

Used for confidentiality.

---

# Symmetric Encryption

Uses **same key** for encrypt and decrypt.

|Algorithm|Notes|
|---|---|
|AES|Modern standard|
|Blowfish|Secure|
|DES|Deprecated|
|XOR|Simple, weak|

Example:

```python
cipher = xor("password", "key")
plain = xor(cipher, "key")
```

---

# Asymmetric Encryption

Uses **two keys:**

|Key|Purpose|
|---|---|
|Public key|Encrypt|
|Private key|Decrypt|

Examples:

|Algorithm|Use|
|---|---|
|RSA|Encryption|
|ECC|Modern crypto|
|Diffie-Hellman|Key exchange|

Used in HTTPS.

---
