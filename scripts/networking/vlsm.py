#vlsm script voor examen NetworkEss
import ipaddress

def next_power_of_two(n):
    """Return the smallest power-of-two greater or equal to n."""
    p = 1
    while p < n:
        p <<= 1
    return p

def main():
    base_input = input("Enter base network (e.g., 192.168.1.0/24): ").strip()
    try:
        base_network = ipaddress.ip_network(base_input, strict=False)
    except ValueError:
        print("Invalid network input.")
        return

    # Get network size requirements
    requirements = []
    print("Enter host requirements. Type 0 to finish.")
    while True:
        size = int(input("Hosts needed: "))
        if size == 0:
            break
        requirements.append(size)

    # Sort by descending host requirements
    requirements.sort(reverse=True)

    print("\n--- VLSM Calculation ---")
    current_ip = base_network.network_address

    for hosts in requirements:
        needed = hosts + 2  # network + broadcast
        block_size = next_power_of_two(needed)
        new_prefix = 32 - (block_size.bit_length() - 1)

        subnet = ipaddress.ip_network(f"{current_ip}/{new_prefix}", strict=False)

        print(f"\nSubnet for {hosts} hosts:")
        print(f"  Network:     {subnet.network_address}")
        print(f"  Prefix:      /{new_prefix}")
        print(f"  Netmask:     {subnet.netmask}")
        print(f"  Broadcast:   {subnet.broadcast_address}")

        # Usable range
        if subnet.num_addresses > 2:
            first_host = list(subnet.hosts())[0]
            last_host = list(subnet.hosts())[-1]
            print(f"  Host range:  {first_host} - {last_host}")
        else:
            print("  Host range:  N/A")

        print(f"  Total hosts: {subnet.num_addresses - 2}")

        # Update current IP for next subnet
        current_ip = subnet.broadcast_address + 1

    print("\nVLSM calculation complete.\n")

if __name__ == "__main__":
    main()