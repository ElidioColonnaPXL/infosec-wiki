#!/usr/bin/env bash
set -u
###
#It does four useful things:

#runs continuously in verbose mode
#tracks outage count
#tracks how long each outage lasts
#gives a best-effort reason for the failure:
#link/carrier lost
#no DHCP / no IP
#no default route
#modem/gateway unreachable
#upstream/ISP problem
#DNS problem

INTERVAL=2
IFACE=""
PUBLIC_IP="1.1.1.1"
DNS_NAME="example.com"
VERBOSE=0
LOGFILE=""

FAIL_COUNT=0
OUTAGE_ACTIVE=0
OUTAGE_START=0
OUTAGE_REASON=""
TOTAL_FAILED_SECONDS=0

usage() {
    cat <<EOF
Usage: $0 -i <interface> [-t seconds] [-p public_ip] [-d dns_name] [-l logfile] [-v]

Options:
  -i <interface>   Network interface to monitor (required), e.g. eth0 or enp3s0
  -t <seconds>     Interval between checks (default: 2)
  -p <public_ip>   Public IP to test upstream connectivity (default: 1.1.1.1)
  -d <dns_name>    DNS name to resolve (default: example.com)
  -l <logfile>     Log output to file as well
  -v               Verbose output
  -h               Show this help
EOF
    exit 1
}

while getopts ":i:t:p:d:l:vh" opt; do
    case "$opt" in
        i) IFACE="$OPTARG" ;;
        t) INTERVAL="$OPTARG" ;;
        p) PUBLIC_IP="$OPTARG" ;;
        d) DNS_NAME="$OPTARG" ;;
        l) LOGFILE="$OPTARG" ;;
        v) VERBOSE=1 ;;
        h) usage ;;
        \?) echo "Unknown option: -$OPTARG"; usage ;;
        :) echo "Missing value for -$OPTARG"; usage ;;
    esac
done

[[ -z "$IFACE" ]] && usage

for cmd in ip ping awk grep date; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Missing required command: $cmd"
        exit 1
    }
done

log() {
    local msg="$1"
    echo "$msg"
    if [[ -n "$LOGFILE" ]]; then
        echo "$msg" >> "$LOGFILE"
    fi
}

alert() {
    local msg="$1"
    printf '\a' 2>/dev/null || true
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "netwatch: outage detected" "$msg" 2>/dev/null || true
    fi
}

sec_to_hms() {
    local s="$1"
    printf '%02dh:%02dm:%02ds' $((s/3600)) $(((s%3600)/60)) $((s%60))
}

iface_exists() {
    [[ -d "/sys/class/net/$IFACE" ]]
}

carrier_state() {
    local carrier="unknown"
    local operstate="unknown"

    [[ -r "/sys/class/net/$IFACE/carrier" ]] && carrier="$(cat "/sys/class/net/$IFACE/carrier" 2>/dev/null)"
    [[ -r "/sys/class/net/$IFACE/operstate" ]] && operstate="$(cat "/sys/class/net/$IFACE/operstate" 2>/dev/null)"

    echo "$carrier|$operstate"
}

ipv4_addr() {
    ip -4 addr show dev "$IFACE" 2>/dev/null | awk '/inet / {print $2; exit}'
}

default_gateway() {
    ip route show default dev "$IFACE" 2>/dev/null | awk '/default/ {print $3; exit}'
}

has_default_route() {
    ip route show default dev "$IFACE" 2>/dev/null | grep -q '^default'
}

ping_ok() {
    local target="$1"
    ping -I "$IFACE" -c 1 -W 1 "$target" >/dev/null 2>&1
}

dns_ok() {
    if command -v dig >/dev/null 2>&1; then
        dig +time=2 +tries=1 +short "$DNS_NAME" >/dev/null 2>&1
        return $?
    elif command -v drill >/dev/null 2>&1; then
        drill "$DNS_NAME" >/dev/null 2>&1
        return $?
    elif command -v nslookup >/dev/null 2>&1; then
        nslookup "$DNS_NAME" >/dev/null 2>&1
        return $?
    else
        getent ahostsv4 "$DNS_NAME" >/dev/null 2>&1
        return $?
    fi
}

reason_hint() {
    case "$1" in
        INTERFACE_MISSING) echo "Interface does not exist." ;;
        LINK_DOWN) echo "Ethernet carrier/link is down. Cable, NIC, or modem port issue." ;;
        NO_IPV4) echo "No IPv4 address on interface. Likely DHCP / modem lease problem." ;;
        NO_DEFAULT_ROUTE) echo "No default route present. Likely DHCP or routing issue." ;;
        NO_GATEWAY) echo "No gateway learned on the interface." ;;
        GATEWAY_UNREACHABLE) echo "Local link exists but modem/default gateway is not responding." ;;
        INTERNET_UNREACHABLE) echo "Gateway responds but public IP does not. Likely modem upstream / ISP issue." ;;
        DNS_FAILURE) echo "Internet IP reachability works, but DNS resolution fails." ;;
        OK) echo "Connectivity looks healthy." ;;
        *) echo "Unknown state." ;;
    esac
}

start_outage() {
    local reason="$1"
    local now
    now=$(date +%s)

    if [[ "$OUTAGE_ACTIVE" -eq 0 ]]; then
        OUTAGE_ACTIVE=1
        OUTAGE_START="$now"
        OUTAGE_REASON="$reason"
        ((FAIL_COUNT++))
        local msg="OUTAGE #$FAIL_COUNT | reason=$reason | $(reason_hint "$reason")"
        log "[$(date '+%F %T')] $msg"
        alert "$msg"
    elif [[ "$OUTAGE_REASON" != "$reason" ]]; then
        OUTAGE_REASON="$reason"
        log "[$(date '+%F %T')] OUTAGE reason changed -> $reason | $(reason_hint "$reason")"
    fi
}

end_outage() {
    local now duration
    now=$(date +%s)
    duration=$((now - OUTAGE_START))
    TOTAL_FAILED_SECONDS=$((TOTAL_FAILED_SECONDS + duration))

    log "[$(date '+%F %T')] RECOVERED | outage_duration=$(sec_to_hms "$duration") | failed_count=$FAIL_COUNT"
    OUTAGE_ACTIVE=0
    OUTAGE_START=0
    OUTAGE_REASON=""
}

print_summary() {
    local active_note=""
    local total="$TOTAL_FAILED_SECONDS"

    if [[ "$OUTAGE_ACTIVE" -eq 1 ]]; then
        local now
        now=$(date +%s)
        total=$((total + now - OUTAGE_START))
        active_note=" (current outage still active)"
    fi

    echo
    echo "========== netwatch summary =========="
    echo "Interface           : $IFACE"
    echo "Public IP test      : $PUBLIC_IP"
    echo "DNS name test       : $DNS_NAME"
    echo "Failed connections  : $FAIL_COUNT"
    echo "Total failed time   : $(sec_to_hms "$total")$active_note"
    echo "======================================"
}

trap 'print_summary; exit 0' INT TERM

log "[$(date '+%F %T')] Starting netwatch on interface=$IFACE interval=${INTERVAL}s public_ip=$PUBLIC_IP dns_name=$DNS_NAME"

while true; do
    TS="$(date '+%F %T')"
    STATE="OK"
    DETAILS=""

    if ! iface_exists; then
        STATE="INTERFACE_MISSING"
        DETAILS="interface=$IFACE not found"
    else
        IFS='|' read -r CARRIER OPERSTATE <<< "$(carrier_state)"
        IPV4="$(ipv4_addr)"
        GW="$(default_gateway)"

        if [[ "$CARRIER" == "0" || "$OPERSTATE" == "down" || "$OPERSTATE" == "dormant" || "$OPERSTATE" == "lowerlayerdown" ]]; then
            STATE="LINK_DOWN"
            DETAILS="carrier=$CARRIER operstate=$OPERSTATE"
        elif [[ -z "${IPV4:-}" ]]; then
            STATE="NO_IPV4"
            DETAILS="carrier=$CARRIER operstate=$OPERSTATE ipv4=none"
        elif ! has_default_route; then
            STATE="NO_DEFAULT_ROUTE"
            DETAILS="ipv4=$IPV4 gateway=none"
        elif [[ -z "${GW:-}" ]]; then
            STATE="NO_GATEWAY"
            DETAILS="ipv4=$IPV4 gateway=none"
        else
            if ping_ok "$GW"; then
                GW_OK="yes"
            else
                GW_OK="no"
            fi

            if [[ "$GW_OK" == "no" ]]; then
                STATE="GATEWAY_UNREACHABLE"
                DETAILS="ipv4=$IPV4 gateway=$GW gateway_ping=fail"
            else
                if ping_ok "$PUBLIC_IP"; then
                    NET_OK="yes"
                else
                    NET_OK="no"
                fi

                if [[ "$NET_OK" == "no" ]]; then
                    STATE="INTERNET_UNREACHABLE"
                    DETAILS="ipv4=$IPV4 gateway=$GW gateway_ping=ok public_ping=fail"
                else
                    if dns_ok; then
                        DNS_OK="yes"
                    else
                        DNS_OK="no"
                    fi

                    if [[ "$DNS_OK" == "no" ]]; then
                        STATE="DNS_FAILURE"
                        DETAILS="ipv4=$IPV4 gateway=$GW gateway_ping=ok public_ping=ok dns=fail"
                    else
                        STATE="OK"
                        DETAILS="ipv4=$IPV4 gateway=$GW gateway_ping=ok public_ping=ok dns=ok"
                    fi
                fi
            fi
        fi
    fi

    if [[ "$STATE" == "OK" ]]; then
        if [[ "$OUTAGE_ACTIVE" -eq 1 ]]; then
            end_outage
        fi
        if [[ "$VERBOSE" -eq 1 ]]; then
            log "[$TS] OK | $DETAILS"
        fi
    else
        start_outage "$STATE"
        if [[ "$OUTAGE_ACTIVE" -eq 1 ]]; then
            NOW=$(date +%s)
            OUTAGE_ELAPSED=$((NOW - OUTAGE_START))
            log "[$TS] FAIL | reason=$STATE | elapsed=$(sec_to_hms "$OUTAGE_ELAPSED") | $DETAILS | $(reason_hint "$STATE")"
        fi
    fi

    sleep "$INTERVAL"
done