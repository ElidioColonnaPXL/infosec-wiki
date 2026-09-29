# TCPdump Cheatsheet

| **Command**                        | **Description**                                                                                                                                                                   |                                                                                                                                                                                                                                 |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `tcpdump --version`                | Prints the tcpdump and libpcap version strings then exits.                                                                                                                        |                                                                                                                                                                                                                                 |
| `tcpdump -h`                       | Prints the help and usage information.                                                                                                                                            |                                                                                                                                                                                                                                 |
| `tcpdump -D`                       | Prints a list of usable network interfaces from which tcpdump can capture.                                                                                                        |                                                                                                                                                                                                                                 |
| `tcpdump -i (interface name or #)` | Executes tcpdump and utilizes the interface specified to capture on.                                                                                                              |                                                                                                                                                                                                                                 |
| `tcpdump -i (int) -w file.pcap`    | Runs a capture on the specified interface and writes the output to a file.                                                                                                        |                                                                                                                                                                                                                                 |
| `tcpdump -r file.pcap`             | TCPDump will read the output from a specified file.                                                                                                                               |                                                                                                                                                                                                                                 |
| `tcpdump -r/-w file.pcap -l \\     | grep 'string'`                                                                                                                                                                    | TCPDump will utilize the capture traffic from a live capture or a file and set stdout as line-buffered. We can then utilize pipe (\|) to send that output to other tools such as grep to look for strings or specific patterns. |
| `tcpdump -i (int) host (ip)`       | TCPDump will start a capture on the interface specified at (int) and will only capture traffic originating from or destined to the IP address or hostname specified after `host`. |                                                                                                                                                                                                                                 |
| `tcpdump -i (int) port (#)`        | Will filter the capture for anything sourcing from or destined to port (#) and discard the rest.                                                                                  |                                                                                                                                                                                                                                 |
| `tcpdump -i (int) proto (#)`       | Will filter the capture for any protocol traffic matching the (#). For example, (6) would filter for any TCP traffic and discard the rest.                                        |                                                                                                                                                                                                                                 |
| `tcpdump -i (int) (proto name)`    | Will utilize a protocols common name to filter the traffic captured. TCP/UDP/ICMP as examples.                                                                                    |                                                                                                                                                                                                                                 |

---

## Tcpdump Common Switches and Filters

|**Switch/Filter**|**Description**|
|---|---|
|`D`|Will display any interfaces available to capture from.|
|`i`|Selects an interface to capture from. ex. -i eth0|
|`n`|Do not resolve hostnames.|
|`nn`|Do not resolve hostnames or well-known ports.|
|`e`|Will grab the ethernet header along with upper-layer data.|
|`X`|Show Contents of packets in hex and ASCII.|
|`XX`|Same as X, but will also specify ethernet headers. (like using Xe)|
|`v, vv, vvv`|Increase the verbosity of output shown and saved.|
|`c`|Grab a specific number of packets, then quit the program.|
|`s`|Defines how much of a packet to grab.|
|`S`|change relative sequence numbers in the capture display to absolute sequence numbers. (13248765839 instead of 101)|
|`q`|Print less protocol information.|
|`r file.pcap`|Read from a file.|
|`w file.pcap`|Write into a file|
|`host`|Host will filter visible traffic to show anything involving the designated host. Bi-directional|
|`src / dest`|`src` and `dest` are modifiers. We can use them to designate a source or destination host or port.|
|`net`|`net` will show us any traffic sourcing from or destined to the network designated. It uses / notation.|
|`proto`|will filter for a specific protocol type. (ether, TCP, UDP, and ICMP as examples)|
|`port`|`port` is bi-directional. It will show any traffic with the specified port as the source or destination.|
|`portrange`|`Portrange` allows us to specify a range of ports. (0-1024)|
|`less / greater "< >"`|`less` and `greater` can be used to look for a packet or protocol option of a specific size.|
|`and / &&`|`and` `&&` can be used to concatenate two different filters together. for example, src host AND port.|
|`or`|`or` Or allows for a match on either of two conditions. It does not have to meet both. It can be tricky.|
|`not`|`not` is a modifier saying anything but x. For example, not UDP.|
