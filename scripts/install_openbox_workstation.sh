#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="Openbox Workstation"
VERSION="1.1"
STATE_DIR="$HOME/.local/share/openbox-workstation"
LOG_DIR="$STATE_DIR/logs"

LOG_FILE="$LOG_DIR/install.log"
MANIFEST="$STATE_DIR/install-manifest"
ROLLBACK_DIR="$STATE_DIR/rollback"
WORKDIR="$(mktemp -d)"

CONFIG_URL="file:///home/sbn/Downloads/openbox_workstation_project_v1.1/scripts/openbox-workstation-config-v1.1.zip"

# --------------------------------------------------
# Required packages
# --------------------------------------------------

PACKAGES=(
  openbox xorg
  tint2 xfce4-panel xfce4-whiskermenu-plugin plank jgmenu
  picom feh conky-all xfce4-notifyd gnome-screensaver
  network-manager-gnome blueman xfce4-power-manager playerctl
  fonts-inter lxappearance
  scrot imagemagick xclip arandr
  policykit-1-gnome
  curl unzip
)

# --------------------------------------------------
# User configuration (managed by Openbox Workstation)
# --------------------------------------------------

CONFIG_TARGETS=(
  "$HOME/.gtkrc-2.0"
  "$HOME/.conkyrc"
  "$HOME/.compton.conf"
  "$HOME/WELCOME.txt"
  "$HOME/.local/share/applications/AppearanceTheme.desktop"
  "$HOME/.local/share/applications/Conky.desktop"
  "$HOME/.conky-google-now"
  "$HOME/.config/picom"
  "$HOME/.config/xfce4"
  "$HOME/.config/tint2"
  "$HOME/.config/plank"
  "$HOME/.config/jgmenu"
  "$HOME/.config/openbox"
)

# --------------------------------------------------
# Shared desktop assets (Preserved on uninstall)
# --------------------------------------------------

SHARED_ASSETS=(
  "$HOME/.local/share/fonts/raleway-elementary"
  "$HOME/.local/share/fonts/open-sans"
  "$HOME/.local/share/themes/Mistral-Thin"
)

# --------------------------------------------------
# User-level autostart overrides
# --------------------------------------------------

USER_AUTOSTART_OVERRIDES=(
  "$HOME/.config/autostart/blueman.desktop"
  "$HOME/.config/autostart/nm-applet.desktop"
)

# --------------------------------------------------
# Logging and cleanup
# --------------------------------------------------

mkdir -p "$STATE_DIR" "$LOG_DIR"
: > "$LOG_FILE"

log() {
    echo "$@" | tee -a "$LOG_FILE"
}

cleanup() {
    rm -rf "$WORKDIR"
}
trap cleanup EXIT

# --------------------------------------------------
# Helper functions
# --------------------------------------------------

is_installed() {
    dpkg -s "$1" >/dev/null 2>&1
}

copy_to_rollback() {
    local src="$1"
    local dest

    if [ -e "$src" ]; then
        dest="$ROLLBACK_DIR/${src#$HOME/}"
        mkdir -p "$(dirname "$dest")"
        cp -a "$src" "$dest"
        log "Rollback snapshot: $src"
    fi
}

create_autostart_override() {
    local source_file="$1"
    local target_file="$2"

    if [ -f "$source_file" ]; then
        mkdir -p "$(dirname "$target_file")"
        cp "$source_file" "$target_file"

        if grep -q '^NotShowIn=' "$target_file"; then
            sed -i 's/^NotShowIn=.*/NotShowIn=GNOME;KDE;/' "$target_file"
        else
            printf '\nNotShowIn=GNOME;KDE;\n' >> "$target_file"
        fi

        log "Created user autostart override: $target_file"
    else
        log "Skipped autostart override, source missing: $source_file"
    fi
}

# --------------------------------------------------
# Start installer
# --------------------------------------------------

log "$PROJECT_NAME Installer"
log "Version: $VERSION"
log "Started: $(date)"
log

# --------------------------------------------------
# Pre-flight checks
# --------------------------------------------------

if ! command -v apt >/dev/null 2>&1; then
    log "ERROR: This installer currently supports only apt-based distributions."
    exit 1
fi

if [ "$CONFIG_URL" = "PASTE_PROJECT_CONFIG_ZIP_URL_HERE" ]; then
    log "ERROR: CONFIG_URL is not set."
    log "Edit this script and set CONFIG_URL to the project configuration ZIP URL."
    exit 1
fi

# --------------------------------------------------
# Detect package state before installation
# --------------------------------------------------

NEW_PACKAGES=()
OLD_PACKAGES=()

for pkg in "${PACKAGES[@]}"; do
    if is_installed "$pkg"; then
        OLD_PACKAGES+=("$pkg")
    else
        NEW_PACKAGES+=("$pkg")
    fi
done

# --------------------------------------------------
# Install required packages
# --------------------------------------------------

log "Installing required packages..."
sudo apt update
sudo apt install -y "${PACKAGES[@]}"

# --------------------------------------------------
# Download and extract workstation configuration
# --------------------------------------------------

log
log "Downloading Openbox Workstation configuration..."
curl -L "$CONFIG_URL" -o "$WORKDIR/openbox-workstation-config.zip"

log "Extracting configuration..."
unzip -q "$WORKDIR/openbox-workstation-config.zip" -d "$WORKDIR"

CONFIG_SOURCE="$WORKDIR/openbox-workstation-config"

if [ ! -d "$CONFIG_SOURCE" ]; then
    log "ERROR: Configuration archive does not contain openbox-workstation-config/"
    exit 1
fi

# --------------------------------------------------
# Create rollback snapshot (useful for users)
# --------------------------------------------------

log
log "Creating rollback snapshot..."
rm -rf "$ROLLBACK_DIR"
mkdir -p "$ROLLBACK_DIR"

for path in "${CONFIG_TARGETS[@]}" "${SHARED_ASSETS[@]}" "${USER_AUTOSTART_OVERRIDES[@]}"; do
    copy_to_rollback "$path"
done

# --------------------------------------------------
# Install workstation configuration
# --------------------------------------------------

log
log "Installing workstation configuration..."
cp -a "$CONFIG_SOURCE/." "$HOME/"

# --------------------------------------------------
# Create user-level autostart overrides
# --------------------------------------------------

log
log "Creating user-level autostart overrides..."
create_autostart_override "/etc/xdg/autostart/blueman.desktop" "$HOME/.config/autostart/blueman.desktop"
create_autostart_override "/etc/xdg/autostart/nm-applet.desktop" "$HOME/.config/autostart/nm-applet.desktop"

# --------------------------------------------------
# Write install manifest
# --------------------------------------------------

log
log "Writing install manifest..."

cat > "$MANIFEST" <<EOF
Openbox Workstation Install Manifest
Version: $VERSION
Installed: $(date)

[Configuration Installed]
EOF

for path in "${CONFIG_TARGETS[@]}"; do
    echo "$path" >> "$MANIFEST"
done

cat >> "$MANIFEST" <<EOF

[Shared Assets Installed]
EOF

for path in "${SHARED_ASSETS[@]}"; do
    echo "$path" >> "$MANIFEST"
done

cat >> "$MANIFEST" <<EOF

[User Autostart Overrides]
EOF

for path in "${USER_AUTOSTART_OVERRIDES[@]}"; do
    echo "$path" >> "$MANIFEST"
done

cat >> "$MANIFEST" <<EOF

[Packages Newly Installed]
EOF

for pkg in "${NEW_PACKAGES[@]}"; do
    echo "$pkg" >> "$MANIFEST"
done

cat >> "$MANIFEST" <<EOF

[Packages Already Present]
EOF

for pkg in "${OLD_PACKAGES[@]}"; do
    echo "$pkg" >> "$MANIFEST"
done

# --------------------------------------------------
# Completion message
# --------------------------------------------------

log
log "Finished: $(date)"
log "Installation complete."
log
log "Next steps:"
log "1. Log out of your current desktop session."
log "2. At the login screen, select the Openbox session from the session menu."
log "   (Hint: To get session menu, look for gear icon on screen and click it.)"
log "3. Log in."
log "4. Right-click the desktop to access the Openbox menu."

