#!/usr/bin/env bash
#
# Setup-Parrot-Sherlock.sh
# Builds an idempotent Parrot OS workstation for HTB Sherlocks, CDSA labs,
# DFIR triage, Windows event-log analysis, PCAP analysis, and remote access.
#
# Run as your normal desktop user:
#   chmod +x Setup-Parrot-Sherlock.sh
#   ./Setup-Parrot-Sherlock.sh
#
# Optional:
#   ./Setup-Parrot-Sherlock.sh --skip-upgrade
#   ./Setup-Parrot-Sherlock.sh --skip-release-tools
#   ./Setup-Parrot-Sherlock.sh --skip-volatility
#
set -Eeuo pipefail

SKIP_UPGRADE=0
SKIP_RELEASE_TOOLS=0
SKIP_VOLATILITY=0

for arg in "$@"; do
    case "$arg" in
        --skip-upgrade)       SKIP_UPGRADE=1 ;;
        --skip-release-tools) SKIP_RELEASE_TOOLS=1 ;;
        --skip-volatility)    SKIP_VOLATILITY=1 ;;
        -h|--help)
            sed -n '2,18p' "$0"
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg" >&2
            exit 2
            ;;
    esac
done

if [[ $EUID -eq 0 ]]; then
    echo "Run this script as your normal Parrot desktop user, not with sudo."
    echo "The script will request sudo when required."
    exit 2
fi

if ! command -v sudo >/dev/null 2>&1; then
    echo "sudo is required."
    exit 2
fi

sudo -v

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
LOG_DIR="$HOME/DFIR-Setup-Logs"
LOG_FILE="$LOG_DIR/Parrot-Sherlock-Setup-$TIMESTAMP.log"
RESULTS_FILE="$LOG_DIR/Parrot-Sherlock-Setup-$TIMESTAMP-results.tsv"
SUMMARY_FILE="$LOG_DIR/Parrot-Sherlock-Setup-$TIMESTAMP-summary.txt"
FAILURES_FILE="$LOG_DIR/Parrot-Sherlock-Setup-$TIMESTAMP-failures.txt"

mkdir -p "$LOG_DIR"
printf 'status\tcomponent\tdetails\n' > "$RESULTS_FILE"
: > "$FAILURES_FILE"

exec > >(tee -a "$LOG_FILE") 2>&1

SUCCESS_COUNT=0
FAILED_COUNT=0
SKIPPED_COUNT=0
INFO_COUNT=0

record_result() {
    local status="$1"
    local component="$2"
    local details="${3:-}"

    details="${details//$'\t'/ }"
    details="${details//$'\n'/ }"
    printf '%s\t%s\t%s\n' "$status" "$component" "$details" >> "$RESULTS_FILE"

    case "$status" in
        SUCCESS) ((SUCCESS_COUNT+=1)) ;;
        FAILED)
            ((FAILED_COUNT+=1))
            printf '%s: %s\n' "$component" "$details" >> "$FAILURES_FILE"
            ;;
        SKIPPED) ((SKIPPED_COUNT+=1)) ;;
        INFO)    ((INFO_COUNT+=1)) ;;
    esac

    printf '[%-7s] %-32s %s\n' "$status" "$component" "$details"
}

run_step() {
    local component="$1"
    shift

    echo
    echo "==> $component"
    if "$@"; then
        record_result SUCCESS "$component" "completed"
        return 0
    else
        local rc=$?
        record_result FAILED "$component" "exit code $rc"
        return 0
    fi
}

package_candidate_exists() {
    local package="$1"
    local candidate
    candidate="$(apt-cache policy "$package" 2>/dev/null | awk '/Candidate:/ {print $2; exit}')"
    [[ -n "$candidate" && "$candidate" != "(none)" ]]
}

install_apt_package() {
    local package="$1"

    if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "install ok installed"; then
        local version
        version="$(dpkg-query -W -f='${Version}' "$package" 2>/dev/null || true)"
        record_result SUCCESS "APT:$package" "already installed ($version)"
        return 0
    fi

    if ! package_candidate_exists "$package"; then
        record_result SKIPPED "APT:$package" "no candidate in configured Parrot repositories"
        return 0
    fi

    if sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "$package"; then
        local version
        version="$(dpkg-query -W -f='${Version}' "$package" 2>/dev/null || true)"
        record_result SUCCESS "APT:$package" "installed ($version)"
    else
        record_result FAILED "APT:$package" "installation failed"
    fi
}

install_package_group() {
    local title="$1"
    shift

    echo
    echo "================================================================"
    echo "$title"
    echo "================================================================"

    local package
    for package in "$@"; do
        install_apt_package "$package"
    done
}

install_or_update_git_repo() {
    local name="$1"
    local url="$2"
    local destination="$3"

    mkdir -p "$(dirname "$destination")"

    if [[ -d "$destination/.git" ]]; then
        if git -C "$destination" pull --ff-only; then
            record_result SUCCESS "$name" "updated: $destination"
        else
            record_result FAILED "$name" "git update failed: $destination"
        fi
    elif [[ -e "$destination" ]]; then
        record_result FAILED "$name" "destination exists but is not a Git repository: $destination"
    elif git clone --depth 1 "$url" "$destination"; then
        record_result SUCCESS "$name" "installed: $destination"
    else
        record_result FAILED "$name" "git clone failed"
    fi
}

install_hayabusa() {
    local api="https://api.github.com/repos/Yamato-Security/hayabusa/releases/latest"
    local release_json asset_url tag temp_dir archive install_root executable

    release_json="$(curl -fsSL -H 'Accept: application/vnd.github+json' -H 'User-Agent: Parrot-DFIR-Setup' "$api")"
    tag="$(jq -r '.tag_name' <<< "$release_json")"
    asset_url="$(jq -r '
        .assets[]
        | select(.name | test("lin-x64-gnu\\.zip$"))
        | .browser_download_url
    ' <<< "$release_json" | head -n1)"

    if [[ -z "$asset_url" || "$asset_url" == "null" ]]; then
        return 1
    fi

    temp_dir="$(mktemp -d)"
    archive="$temp_dir/hayabusa.zip"
    install_root="/opt/dfir-tools/hayabusa/$tag"

    curl -fL "$asset_url" -o "$archive"
    sudo rm -rf "$install_root"
    sudo mkdir -p "$install_root"
    sudo unzip -q "$archive" -d "$install_root"

    executable="$(sudo find "$install_root" -type f -name 'hayabusa*' ! -name '*.exe' -perm /111 | head -n1)"
    if [[ -z "$executable" ]]; then
        executable="$(sudo find "$install_root" -type f -name 'hayabusa*' ! -name '*.exe' | head -n1)"
        [[ -n "$executable" ]] || return 1
        sudo chmod +x "$executable"
    fi

    sudo ln -sfn "$install_root" /opt/dfir-tools/hayabusa/current
    sudo tee /usr/local/bin/hayabusa >/dev/null <<'WRAPPER'
#!/usr/bin/env bash
set -e
ROOT="/opt/dfir-tools/hayabusa/current"
EXE="$(find "$ROOT" -type f -name 'hayabusa*' ! -name '*.exe' -perm /111 | head -n1)"
cd "$(dirname "$EXE")"
exec "$EXE" "$@"
WRAPPER
    sudo chmod 0755 /usr/local/bin/hayabusa
    rm -rf "$temp_dir"

    hayabusa --version >/dev/null 2>&1 || hayabusa help >/dev/null 2>&1
}

install_chainsaw() {
    local api="https://api.github.com/repos/WithSecureLabs/chainsaw/releases/latest"
    local release_json asset_url asset_name tag temp_dir archive install_root executable

    release_json="$(curl -fsSL -H 'Accept: application/vnd.github+json' -H 'User-Agent: Parrot-DFIR-Setup' "$api")"
    tag="$(jq -r '.tag_name' <<< "$release_json")"

    asset_url="$(jq -r '
        .assets[]
        | select(
            (.name | test("(?i)(x86_64|x64)")) and
            (.name | test("(?i)linux")) and
            (.name | test("(?i)\\.(tar\\.gz|tgz|zip)$")) and
            (.name | test("(?i)(sha256|checksum|sig)") | not)
        )
        | .browser_download_url
    ' <<< "$release_json" | head -n1)"

    if [[ -z "$asset_url" || "$asset_url" == "null" ]]; then
        return 1
    fi

    asset_name="$(basename "$asset_url")"
    temp_dir="$(mktemp -d)"
    archive="$temp_dir/$asset_name"
    install_root="/opt/dfir-tools/chainsaw/$tag"

    curl -fL "$asset_url" -o "$archive"
    sudo rm -rf "$install_root"
    sudo mkdir -p "$install_root"

    case "$asset_name" in
        *.zip) sudo unzip -q "$archive" -d "$install_root" ;;
        *.tar.gz|*.tgz) sudo tar -xzf "$archive" -C "$install_root" ;;
        *) return 1 ;;
    esac

    executable="$(sudo find "$install_root" -type f -name chainsaw | head -n1)"
    [[ -n "$executable" ]] || return 1
    sudo chmod +x "$executable"
    sudo ln -sfn "$executable" /usr/local/bin/chainsaw
    rm -rf "$temp_dir"

    chainsaw --version >/dev/null
}

install_volatility() {
    local root="$HOME/.local/opt/volatility3"
    local venv="$root/venv"

    mkdir -p "$root" "$HOME/.local/bin"
    python3 -m venv "$venv"
    "$venv/bin/python" -m pip install --upgrade pip setuptools wheel
    "$venv/bin/python" -m pip install --upgrade "volatility3[full]" yara-python
    ln -sfn "$venv/bin/vol" "$HOME/.local/bin/vol3"

    "$venv/bin/python" -c \
        "import importlib.metadata; print('Volatility', importlib.metadata.version('volatility3'))"
}

install_oletools() {
    pipx ensurepath >/dev/null 2>&1 || true

    if pipx list --short 2>/dev/null | grep -q '^oletools '; then
        pipx upgrade oletools
    else
        pipx install oletools
    fi
}

create_rdp_compatibility_wrapper() {
    local actual=""

    if command -v xfreerdp3 >/dev/null 2>&1; then
        actual="$(command -v xfreerdp3)"
    elif command -v xfreerdp >/dev/null 2>&1; then
        record_result SUCCESS "RDP compatibility command" "xfreerdp already exists"
        return 0
    else
        record_result FAILED "RDP compatibility command" "no FreeRDP executable found"
        return 0
    fi

    sudo tee /usr/local/bin/xfreerdp >/dev/null <<EOF2
#!/usr/bin/env bash
exec "$actual" "\$@"
EOF2
    sudo chmod 0755 /usr/local/bin/xfreerdp
    record_result SUCCESS "RDP compatibility command" "xfreerdp -> $actual"
}

configure_wireshark_capture() {
    if ! dpkg-query -W -f='${Status}' wireshark-common 2>/dev/null | grep -q "install ok installed"; then
        record_result SKIPPED "Wireshark non-root capture" "wireshark-common is not installed"
        return 0
    fi

    echo "wireshark-common wireshark-common/install-setuid boolean true" |
        sudo debconf-set-selections

    if sudo DEBIAN_FRONTEND=noninteractive dpkg-reconfigure wireshark-common &&
       sudo usermod -aG wireshark "$USER"; then
        record_result SUCCESS "Wireshark non-root capture" "enabled; log out or reboot before use"
    else
        record_result FAILED "Wireshark non-root capture" "configuration failed"
    fi
}

create_case_structure() {
    local root="$HOME/Sherlocks"
    local template="$root/_template"

    mkdir -p \
        "$template/00-original" \
        "$template/01-working" \
        "$template/02-output" \
        "$template/03-screenshots" \
        "$template/04-notes" \
        "$HOME/Tools" \
        "$HOME/Rules" \
        "$HOME/PCAPs"

    cat > "$template/README.md" <<'CASEEOF'
# Sherlock Case Template

- `00-original`: untouched evidence; calculate hashes here
- `01-working`: working copies
- `02-output`: parser output, timelines, extracted artifacts
- `03-screenshots`: supporting screenshots
- `04-notes`: investigation notes and report material

Create a new case:

```bash
cp -a ~/Sherlocks/_template ~/Sherlocks/CASE-NAME
```
CASEEOF

    record_result SUCCESS "Sherlock case structure" "$template"
}

create_case_helper() {
    mkdir -p "$HOME/.local/bin"

    cat > "$HOME/.local/bin/new-sherlock" <<'HELPEREOF'
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: new-sherlock CASE-NAME" >&2
    exit 2
fi

name="$1"
template="$HOME/Sherlocks/_template"
destination="$HOME/Sherlocks/$name"

if [[ -e "$destination" ]]; then
    echo "Case already exists: $destination" >&2
    exit 1
fi

cp -a "$template" "$destination"
echo "Created: $destination"
HELPEREOF

    chmod +x "$HOME/.local/bin/new-sherlock"

    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        if ! grep -qs 'HOME/.local/bin' "$HOME/.profile"; then
            printf '\n# User CLI tools\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.profile"
        fi
        export PATH="$HOME/.local/bin:$PATH"
    fi

    record_result SUCCESS "new-sherlock helper" "$HOME/.local/bin/new-sherlock"
}

verify_commands() {
    local commands=(
        xfreerdp3 xfreerdp remmina ssh openvpn
        wireshark tshark tcpdump nmap jq rg
        suricata
        fls mmls istat ewfinfo log2timeline.py psort.py
        python3-evtx exiftool yara sqlite3
        testdisk foremost bulk_extractor hashdeep
        binwalk strings objdump readelf gdb strace ltrace
        vol3 oleid olevba
        hayabusa chainsaw
    )

    local command_name
    for command_name in "${commands[@]}"; do
        if command -v "$command_name" >/dev/null 2>&1; then
            record_result SUCCESS "CMD:$command_name" "$(command -v "$command_name")"
        else
            record_result SKIPPED "CMD:$command_name" "not present or command name differs"
        fi
    done
}

echo "================================================================"
echo "Parrot OS Sherlock / CDSA workstation setup"
echo "Started: $(date --iso-8601=seconds)"
echo "User:    $USER"
echo "Host:    $(hostname)"
echo "Log:     $LOG_FILE"
echo "================================================================"

record_result INFO "Operating system" "$(PRETTY_NAME=unknown; source /etc/os-release 2>/dev/null || true; echo "$PRETTY_NAME")"
record_result INFO "Kernel" "$(uname -srmo)"
record_result INFO "Architecture" "$(uname -m)"

run_step "APT metadata refresh" sudo apt-get update

if [[ $SKIP_UPGRADE -eq 0 ]]; then
    if command -v parrot-upgrade >/dev/null 2>&1; then
        run_step "Parrot system upgrade" sudo parrot-upgrade -y
    else
        run_step "Debian full upgrade" sudo DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y
    fi
else
    record_result SKIPPED "System upgrade" "--skip-upgrade supplied"
fi

CORE_PACKAGES=(
    ca-certificates curl wget git jq yq
    ripgrep fd-find tree tmux htop lsof plocate
    unzip zip p7zip-full zstd cabextract unrar-free
    file binutils hexedit vim-common
    python3 python3-pip python3-venv python3-dev pipx
    build-essential pkg-config
)

REMOTE_PACKAGES=(
    freerdp3-x11
    remmina remmina-plugin-rdp
    openssh-client
    openvpn wireguard-tools
)

NETWORK_PACKAGES=(
    wireshark tshark tcpdump tcpflow
    nmap netcat-openbsd socat ngrep
    dnsutils whois traceroute mtr-tiny
    iproute2 ethtool
    suricata
    zeek zkg
)

DFIR_PACKAGES=(
    sleuthkit ewf-tools plaso python3-evtx
    testdisk foremost scalpel bulk-extractor
    hashdeep dc3dd dcfldd
    libimage-exiftool-perl binwalk yara
    sqlite3 csvkit miller
    qemu-utils libguestfs-tools ntfs-3g dislocker
    chntpw reglookup
    afflib-tools libvshadow-utils libbde-utils
    libfsapfs-utils libfsntfs-utils
    poppler-utils
)

ANALYSIS_PACKAGES=(
    gdb strace ltrace radare2
    python3-scapy
    hashcat john
)

install_package_group "Core command-line utilities" "${CORE_PACKAGES[@]}"
install_package_group "Remote access and HTB connectivity" "${REMOTE_PACKAGES[@]}"
install_package_group "Network and SOC analysis" "${NETWORK_PACKAGES[@]}"
install_package_group "DFIR and filesystem analysis" "${DFIR_PACKAGES[@]}"
install_package_group "Static analysis and supporting tools" "${ANALYSIS_PACKAGES[@]}"

create_rdp_compatibility_wrapper
configure_wireshark_capture
create_case_structure
create_case_helper

run_step "oletools through pipx" install_oletools

if [[ $SKIP_VOLATILITY -eq 0 ]]; then
    run_step "Volatility 3 isolated environment" install_volatility
else
    record_result SKIPPED "Volatility 3" "--skip-volatility supplied"
fi

if [[ $SKIP_RELEASE_TOOLS -eq 0 ]]; then
    run_step "Hayabusa latest Linux release" install_hayabusa
    run_step "Chainsaw latest Linux release" install_chainsaw

    install_or_update_git_repo \
        "Chainsaw repository" \
        "https://github.com/WithSecureLabs/chainsaw.git" \
        "$HOME/Tools/chainsaw-repository"

    install_or_update_git_repo \
        "Sigma rules" \
        "https://github.com/SigmaHQ/sigma.git" \
        "$HOME/Rules/sigma"
else
    record_result SKIPPED "Hayabusa" "--skip-release-tools supplied"
    record_result SKIPPED "Chainsaw" "--skip-release-tools supplied"
    record_result SKIPPED "Detection repositories" "--skip-release-tools supplied"
fi

if command -v suricata-update >/dev/null 2>&1; then
    run_step "Suricata rules update" sudo suricata-update
else
    record_result SKIPPED "Suricata rules update" "suricata-update command not present"
fi

verify_commands

{
    echo "Parrot Sherlock workstation setup summary"
    echo "Generated: $(date --iso-8601=seconds)"
    echo
    echo "SUCCESS: $SUCCESS_COUNT"
    echo "FAILED:  $FAILED_COUNT"
    echo "SKIPPED: $SKIPPED_COUNT"
    echo "INFO:    $INFO_COUNT"
    echo
    echo "Detailed log:  $LOG_FILE"
    echo "Results table: $RESULTS_FILE"
    echo "Failures:      $FAILURES_FILE"
    echo
    echo "Important:"
    echo "- Log out or reboot before non-root Wireshark capture."
    echo "- Create a case with: new-sherlock CASE-NAME"
    echo "- Current FreeRDP package uses xfreerdp3; an xfreerdp compatibility command was created."
    echo "- Zimmerman Tools, Registry Explorer, MFT Explorer, Timeline Explorer and Autopsy remain on the Windows DFIR VM."
} | tee "$SUMMARY_FILE"

echo
echo "================================================================"
echo "Setup complete"
echo "SUCCESS=$SUCCESS_COUNT FAILED=$FAILED_COUNT SKIPPED=$SKIPPED_COUNT"
echo "Summary: $SUMMARY_FILE"
echo "================================================================"

if [[ $FAILED_COUNT -gt 0 ]]; then
    exit 1
fi
