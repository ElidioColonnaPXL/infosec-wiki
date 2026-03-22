#script to generate cisco router/switch config commands for packet tracer
# by colo with claude llm assistance 6.4
# chech if os works on windows or linux for clear screen
import os

# check library for clear screen on windows 
# this is correct for linux
# for bash and zsh
def clear_screen():
    os.system("cls" if os.name == "nt" else "clear")

# show current config preview to user
def show_current_config(commands):
    print("=== HUIDIGE CONFIGURATIE (PREVIEW) ===")
    if not commands:
        print("(nog geen commando's)")
    else:
        for cmd in commands:
            print(cmd)
    print("=" * 40)

# menu interface
def print_menu():
    print("""
=== Cisco Config Generator ===
1  Hostname instellen
2  Klok instellen
3  Enable password
4  Enable secret
5  Console wachtwoord
6  VTY wachtwoord (Telnet)
7  SSH configuratie (volledig)
8  Telnet + SSH toestaan (VTY)
9  Service password-encryption
10 MOTD banner
11 IPv4 adres op interface
12 IPv6 adres op interface
13 Interface no shutdown
14 Default gateway (switch)
15 Static route (router)
16 Config opslaan (copy run start)

0  Show result
""")

# always return base config commands
def base_config():
    return ["enable", "conf t"]


def main():
    commands = []

    while True:
        clear_screen()
        show_current_config(commands)
        print_menu()

        keuze = input("Maak een keuze: ").strip()

        if not keuze.isdigit():
            continue

        keuze = int(keuze)

        if keuze == 0:
            clear_screen()
            print("=== RESULTAAT (COPY / PASTE) ===\n")
            for cmd in commands:
                print(cmd)

            print("\n0 = Stoppen")
            print("1 = Verder configureren (append)")
            vervolg = input("Keuze: ").strip()

            if vervolg == "0":
                  # <-- BELANGRIJK: script stopt, scherm blijft staan
                clear_screen()
                for cmd in commands:
                    print(cmd)
                return

            elif vervolg == "1":
                continue
            else:
                return


        elif keuze == 1:
            naam = input("Hostname: ")
            commands += base_config()
            commands.append(f"hostname {naam}")

        elif keuze == 2:
            tijd = input("Tijd (HH:MM:SS): ")
            datum = input("Datum (bv. 31 Jan 2026): ")
            commands.append(f"clock set {tijd} {datum}")

        elif keuze == 3:
            pw = input("Enable password: ")
            commands += base_config()
            commands.append(f"enable password {pw}")

        elif keuze == 4:
            pw = input("Enable secret: ")
            commands += base_config()
            commands.append(f"enable secret {pw}")

# klopt niet altijd met og script
        elif keuze == 5:
            pw = input("Console password: ")
            commands += base_config()
            commands += [
                "line console 0",
                f"password {pw}",
                "login",
                "exit"
            ]

        elif keuze == 6:
            pw = input("VTY password (Telnet): ")
            commands += base_config()
            commands += [
                "line vty 0 15",
                f"password {pw}",
                "login",
                "transport input telnet",
                "exit"
            ]
# toegevoegd ssh config pas op met ftpd
        elif keuze == 7:
            domain = input("Domain-name: ")
            user = input("Username: ")
            pw = input("User password: ")
            bits = input("RSA key grootte (1024/2048): ")

            commands += base_config()
            commands += [
                f"ip domain-name {domain}",
                f"username {user} privilege 15 secret {pw}",
                "crypto key generate rsa",
                bits,
                "ip ssh version 2",
                "line vty 0 15",
                "login local",
                "transport input ssh",
                "exit"
            ]

        elif keuze == 8:
            commands += base_config()
            commands += [
                "line vty 0 15",
                "login local",
                "transport input telnet ssh",
                "exit"
            ]

        elif keuze == 9:
            commands += base_config()
            commands.append("service password-encryption")

        elif keuze == 10:
            tekst = input("MOTD banner tekst: ")
            commands += base_config()
            commands.append(f"banner motd #{tekst}#")

        elif keuze == 11:
            iface = input("Interface (bv. g0/0): ")
            ip = input("IPv4 adres: ")
            mask = input("Subnetmasker: ")
            commands += base_config()
            commands += [
                f"interface {iface}",
                f"ip address {ip} {mask}",
                "no shutdown",
                "exit"
            ]

        elif keuze == 12:
            iface = input("Interface: ")
            ipv6 = input("Global IPv6 adres (2001:db8::1/64): ")
            ll = input("Link-local adres (bv. FE80::1) [leeg = automatisch]: ").strip()

            commands += base_config()
            commands += [
                "ipv6 unicast-routing",
                f"interface {iface}",
            ]

            # link-local configuratie
            if ll == "":
                commands.append("ipv6 enable")   # automatisch link-local
            else:
                commands.append(f"ipv6 address {ll} link-local")

            # global IPv6 adres
            commands += [
                f"ipv6 address {ipv6}",
                "no shutdown",
                "exit"
            ]


        elif keuze == 13:
            iface = input("Interface: ")
            commands += base_config()
            commands += [
                f"interface {iface}",
                "no shutdown",
                "exit"
            ]

        elif keuze == 14:
            gw = input("Default gateway: ")
            commands += base_config()
            commands.append(f"ip default-gateway {gw}")

        elif keuze == 15:
            net = input("Netwerk: ")
            mask = input("Subnetmasker: ")
            hop = input("Next-hop: ")
            commands += base_config()
            commands.append(f"ip route {net} {mask} {hop}")

        elif keuze == 16:
            commands.append("copy running-config startup-config")


if __name__ == "__main__":
    main()
