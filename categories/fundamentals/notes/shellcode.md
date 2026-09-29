# Shellcode

Shellcode is compact machine code designed to run within another process. The name is historical: modern payloads may collect information, load another component, or invoke operating-system services rather than open a command shell.

## Design properties

- **Architecture-specific:** instruction encoding, registers, calling conventions, and system-call interfaces differ between platforms.
- **Position-independent:** the code often cannot assume a fixed load address.
- **Constrained:** an injection path may reject null bytes, whitespace, or other values.
- **Context-dependent:** memory permissions, process integrity, available libraries, and mitigations determine whether execution is possible.
- **Staged or self-contained:** a small first stage may locate or retrieve a larger component, while a single-stage payload carries all required logic.

## Analysis workflow

Treat unknown shellcode as untrusted binary evidence. Preserve the original bytes and hash, identify the likely architecture and byte order, disassemble without executing, map strings and API or system-call behavior, and use emulation or an isolated instrumented environment when dynamic observation is necessary. Record entry assumptions, decoded layers, memory writes, network indicators, and termination behavior.

## Defensive controls

Data-execution prevention, address-space randomization, control-flow protections, application isolation, exploit mitigations, and rapid patching raise the cost of shellcode execution. Endpoint telemetry can add visibility into unusual executable memory, cross-process writes, suspicious thread creation, and unexpected network activity.
