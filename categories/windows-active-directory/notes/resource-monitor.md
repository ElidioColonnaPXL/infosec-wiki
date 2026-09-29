# Resource Monitor

Resource Monitor is a built-in Windows utility for examining live CPU, memory, disk, and network activity. Open it with `resmon.exe` or from Task Manager's performance view.

## Views

- **CPU** associates processes with services, handles, and loaded modules.
- **Memory** shows working sets, commit, hard faults, and how physical memory is allocated.
- **Disk** maps processes to file activity, throughput, response time, and storage queues.
- **Network** shows per-process connections, listening ports, remote endpoints, and transfer rates.

## Investigation use

Begin with the Overview tab, identify the process responsible for an unusual resource pattern, and then pivot to its detailed tab. Correlate process identifiers, paths, users, timestamps, and endpoints with event logs and other telemetry. Resource Monitor is a live troubleshooting view: it does not retain a complete history, so preserve relevant evidence with an appropriate collection method before terminating a process or changing the system.
