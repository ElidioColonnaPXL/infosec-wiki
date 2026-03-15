# Nibbles

# Enumeration

## Services
with following Nmap scan

    nmap -sC -sV STMIP

- 22 **SSH** OpenSSH 7.2p2 Ubuntu 4ubuntu2.2 (Ubuntu Linux; protocol 2.0)
- 80 **HTTP** Apache/2.4.18 (Ubuntu)

![nmap scan](images/Pasted image 20260315203153.png)

## Web Footprint
http://10.129.20.39 is just a blank page with "Hello world!"

![web page](images/Pasted image 20260315203440.png)

But when we look in the source code

![source code](images/Pasted image 20260315203546.png)

/nibbleblog is our next step

![nibbleblog](images/Pasted image 20260315203758.png)

All links are inactive and a dead end so next is webfuzzing

    ffuf -u http://10.129.20.39/nibbleblog/FUZZ -w /usr/share/wordlists/dirb/common.txt -mc all -fc 404

we have some hits

    .htpasswd               [Status: 403, Size: 307, Words: 22, Lines: 12, Duration: 96ms]
    [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 105ms]
    admin                   [Status: 301, Size: 323, Words: 20, Lines: 10, Duration: 82ms]
    admin.php               [Status: 200, Size: 1401, Words: 79, Lines: 27, Duration: 201ms]
    .hta                    [Status: 403, Size: 302, Words: 22, Lines: 12, Duration: 4759ms]
    .htaccess               [Status: 403, Size: 307, Words: 22, Lines: 12, Duration: 4765ms]
    content                 [Status: 301, Size: 325, Words: 20, Lines: 10, Duration: 99ms]
    index.php               [Status: 200, Size: 2987, Words: 116, Lines: 61, Duration: 86ms]
    languages               [Status: 301, Size: 327, Words: 20, Lines: 10, Duration: 89ms]
    plugins                 [Status: 301, Size: 325, Words: 20, Lines: 10, Duration: 86ms]
    README                  [Status: 200, Size: 4628, Words: 589, Lines: 64, Duration: 74ms]
    themes                  [Status: 301, Size: 324, Words: 20, Lines: 10, Duration: 87ms]
    :: Progress: [4614/4614] :: Job [1/1] :: 443 req/sec :: Duration: [0:00:15] :: Errors: 0 ::