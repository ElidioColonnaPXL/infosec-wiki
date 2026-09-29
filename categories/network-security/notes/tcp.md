# TCP

> **Note:**
> Transmission Control Protocol provides reliable, ordered, connection-oriented byte streams over IP.

## Core behavior

- Connection establishment normally uses the SYN, SYN-ACK, ACK three-way handshake.
- Sequence and acknowledgement numbers provide ordered delivery and retransmission.
- FIN or RST tears down a connection.
- Flow control uses the receive window; congestion control adapts sender behavior to network conditions.

## Investigation pivots

- Incomplete handshakes, repeated SYNs and unusual RST patterns.
- Long-lived low-volume sessions and periodic beacon-like connections.
- Unexpected destination ports, external endpoints or process-to-socket relationships.
- Retransmissions, zero-window conditions and asymmetric capture effects.

## Related

- UDP
- TCP-IP Model
- Wireshark
- TCPdump
