# Ports and Services

Use this note for service/port lookup. Detailed behavior and investigation guidance belongs in the individual protocol notes.

| Port | Transport | Common service |
|---:|---|---|
| 20/21 | TCP | FTP |
| 22 | TCP | SSH |
| 23 | TCP | Telnet |
| 25 | TCP | SMTP |
| 53 | UDP/TCP | DNS |
| 67/68 | UDP | DHCP |
| 80 | TCP | HTTP |
| 88 | UDP/TCP | Kerberos |
| 110 | TCP | POP3 |
| 123 | UDP | NTP |
| 135 | TCP | MSRPC |
| 137-139 | UDP/TCP | NetBIOS |
| 143 | TCP | IMAP |
| 161/162 | UDP | SNMP |
| 389 | UDP/TCP | LDAP |
| 443 | TCP/UDP | HTTPS / QUIC |
| 445 | TCP | SMB |
| 465/587 | TCP | SMTP submission |
| 623 | UDP | IPMI |
| 636 | TCP | LDAPS |
| 993 | TCP | IMAPS |
| 995 | TCP | POP3S |
| 1433/1434 | TCP/UDP | MSSQL |
| 1521 | TCP | Oracle TNS |
| 2049 | TCP/UDP | NFS |
| 3306 | TCP | MySQL |
| 3389 | TCP/UDP | RDP |
| 5985/5986 | TCP | WinRM |

## Original detailed notes

A `port` is a number assigned to specific processes or services on a network to help computers sort and direct network traffic correctly. It functions at the `Transport Layer (Layer 4)` of the OSI model and works with protocols such as TCP and UDP. Ports facilitate the simultaneous operation of multiple network services on a single IP address by differentiating traffic intended for different applications.

When a client application initiates a connection, it specifies the destination port number corresponding to the desired service. Client applications are those who request data or services, while server applications respond to those requests and provide the data or services. The operating system then directs the incoming traffic to the correct application based on this port number. Consider a simple example where a user accesses a website: the user’s browser initiates a connection to the server's IP address on port 80, which is designated for HTTP. The server, listening on this port, responds to the request. If the user needs to access a secure site, the browser instead connects to port 443, the standard for HTTPS, ensuring secure communication. Port numbers range from `0` to `65535`, and it is divided into three main categories, each serving a specific function.

#### Well-Known Ports (0-1023):

`Well-known ports`, numbered from 0 to 1023, are reserved for common and universally recognized services and protocols, as standardized and managed by the [Internet Assigned Numbers Authority (IANA)](https://www.iana.org/). For instance, HTTP, which is the foundation of data communication for the World Wide Web, uses port 80, although browsers typically do not display this port number to simplify user experience. Similarly, HTTPS uses port 443 for secure communications over networks, and this port is also generally not displayed by browsers. Another example is FTP, which facilitates file transfers between clients and servers, using ports 20 and 21.

#### Registered Ports (1024-49151):

`Registered ports`, which range from 1024 to 49151, are not as strictly regulated as `well-known ports` but are still registered and assigned to specific services by the Internet Assigned Numbers Authority (IANA). These ports are commonly used for external services that users might install on a device. For instance, many database services, such as Microsoft SQL Server, use port 1433. Software companies frequently register a port for their applications to ensure that their software consistently uses the same port on any system. This registration helps in managing network traffic and preventing port conflicts across different applications.

#### Dynamic/Private Ports (49152-65535):

Dynamic or private ports, also known as ephemeral ports, range from 49152 to 65535 and are typically used by client applications to send and receive data from servers, such as when a web browser connects to a server on the internet. These ports are called `dynamic` because they are not fixed; rather, they can be randomly selected by the client's operating system as needed for each session. Generally used for temporary communication sessions, these ports are closed once the interaction ends. Additionally, dynamic ports can be assigned to custom server applications, often those handling short-term connections.

# TCP and UDP Ports
