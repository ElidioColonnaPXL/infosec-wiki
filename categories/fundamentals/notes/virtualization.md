# virtualization

Setting Up
Hardware virtualization refers to technologies that allow hardware components to be accessed independently of their physical form through the use of [hypervisor](https://en.wikipedia.org/wiki/Hypervisor) software. The best-known example of this is the `virtual machine (VM)`. A VM is a virtual computer that behaves like a physical computer, from its hardware to the operating system. Virtual machines run as virtual guest systems on one or more physical systems referred to as `hosts`. VirtualBox can also be enhanced with `VirtualBox Guest Additions`, which are a set of drivers and system applications designed to enhance the performance and usability of guest operating systems with VirtualBox.


in the context of virtualization, we typically distinguish between:

- Hardware virtualization
- Application virtualization
- Storage virtualization
- Data virtualization
- Network virtualization
---

## Virtual Machines

A `virtual machine (VM)` is a virtual operating system that runs on a host system (an actual physical computer system)
The most important benefits are:

1. Applications and services of a VM do not interfere with each other

2. Complete independence of the guest system from the host system's operating system and the underlying physical hardware

3. VMs can be moved or cloned to other systems by simple copying

4. Hardware resources can be dynamically allocated via the hypervisor

5. Better and more efficient utilization of existing hardware resources

6. Shorter provisioning times for systems and applications

7. Simplified management of virtual systems

8. Higher availability of VMs due to independence from physical resources


## ProxMox
