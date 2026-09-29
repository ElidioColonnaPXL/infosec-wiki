# Wireshark Cheatsheet

## WireShark

|**Capture Filter**|**Description**|
|---|---|
|`host x.x.x.x`|Capture only traffic pertaining to a certain host|
|`net x.x.x.x/24`|Capture traffic to or from a specific network (using slash notation to specify the mask)|
|`src/dst net x.x.x.x/24`|Using src or dst net will only capture traffic sourcing from the specified network or destined to the target network|
|`port #`|will filter out all traffic except the port you specify|
|`not`|will capture everything except the variable specified. ex. `not port 80`|
|`and`|AND will concatenate your specified ports. ex. `host 192.168.1.1 and port 80`|
|`portrange x-x`|Portrange will grab traffic from all ports within the range only|
|`ip / ether / tcp`|These filters will only grab traffic from specified protocol headers.|
|`broadcast / multicast / unicast`|Grabs a specific type of traffic. one to one, one to many, or one to all.|

| **Display Filter**           | **Description**                                                                                                       |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| `ip.addr == x.x.x.x`         | Capture only traffic pertaining to a certain host. This is an OR statement.                                           |
| `ip.addr == x.x.x.x/24`      | Capture traffic pertaining to a specific network. This is an OR statement.                                            |
| `ip.src/dst == x.x.x.x`      | Capture traffic to or from a specific host.                                                                           |
| `dns / tcp / ftp / arp / ip` | filter traffic by a specific protocol. There are many more options.                                                   |
| `tcp.port == x`              | filter by a specific tcp port.                                                                                        |
| `src.port / dst.port ==x`    | will capture everything except the port specified.                                                                    |
| `and / or / not`             | AND will concatenate, OR will find either of two options, NOT will exclude your input option.                         |
| `tcp.stream eq #`            | Allows us to follow a tcp session in which we captured the entire stream. Replace (#) with the session to reassemble. |
| `http`                       | Will filter for any traffic matching the http protocol.                                                               |
| `http && image-jfif`         | This filter will display any packet with a jpeg image file.                                                           |
| `ftp`                        | Filters for the ftp protocol.                                                                                         |
| `ftp.request.command`        | Will filter for any control commands sent over ftp control channel.                                                   |
| `ftp-data`                   | Will show any objects transfered over ftp.                                                                            |
