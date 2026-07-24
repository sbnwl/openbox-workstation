#!/usr/bin/env bash

# Openbox Workstation
# Copyright (C) 2026 Surendra Beniwal
# SPDX-License-Identifier: GPL-3.0-or-later
#


set -euo pipefail

PROJECT_NAME="Openbox Workstation"
VERSION="1.2"
STATE_DIR="$HOME/.local/share/openbox-workstation"
LOG_DIR="$STATE_DIR/logs"

LOG_FILE="$LOG_DIR/install.log"
MANIFEST="$STATE_DIR/install-manifest"
ROLLBACK_DIR="$STATE_DIR/rollback"
WORKDIR="$(mktemp -d)"

REPO_OWNER="sbnwl"
REPO_NAME="openbox-workstation"
RELEASE_TAG="v${VERSION}"

CONFIG_URL="https://github.com/${REPO_OWNER}/${REPO_NAME}/archive/refs/tags/${RELEASE_TAG}.zip"

# --------------------------------------------------
# Core packages
# --------------------------------------------------

CORE_PACKAGES=(
  openbox xorg
  tint2 xfce4-panel xfce4-whiskermenu-plugin plank jgmenu
  picom feh conky-all xfce4-notifyd gnome-screensaver
  network-manager-gnome blueman xfce4-power-manager playerctl
  fonts-inter lxappearance
  scrot imagemagick xclip arandr
  policykit-1-gnome
  xsettingsd
  curl unzip
)

# --------------------------------------------------
# Optional packages
# --------------------------------------------------

OPTIONAL_PACKAGES=(
  # Convenience applications
      guake
  # Base desktop components if starting from Ubuntu Server / mini.iso systems
    # GRAPHICAL LOGIN MANAGER 
      sddm
    # MISSING GTK THEME, ICONS AND CURSOR
      yaru-theme-gtk yaru-theme-icon dmz-cursor-theme
    # DEPENDENCY TO PARSE *.desktop FILES IN ~/.config/autostart
      python3-xdg
    # DESKTOP BACKGROUNDS
      gnome-backgrounds
)

# --------------------------------------------------
# User configuration (managed by Openbox Workstation)
# --------------------------------------------------

CONFIG_TARGETS=(
  "$HOME/.config/jgmenu"
  "$HOME/.config/openbox"
  "$HOME/.config/picom"
  "$HOME/.config/plank"
  "$HOME/.config/tint2"
  "$HOME/.config/xfce4"
  "$HOME/.conky-google-now"
  "$HOME/.conkyrc"
  "$HOME/.compton.conf"
  "$HOME/.config/gtk-3.0/gtk.css"
  "$HOME/.config/gtk-3.0/settings.ini"
  "$HOME/.config/gtk-3.0/xfce4-panel-tint2.css"
  "$HOME/.gtkrc-2.0"
  "$HOME/.xsettingsd"
  "$HOME/WELCOME.txt"
)

# --------------------------------------------------
# Openbox-specific application launchers
# --------------------------------------------------

OPENBOX_LAUNCHERS=(
  "$HOME/.local/share/applications/lxappearance.desktop"
  "$HOME/.local/share/applications/conky.desktop"
  "$HOME/.local/share/applications/obconf.desktop"
  "$HOME/.local/share/applications/picom.desktop"
  "$HOME/.local/share/applications/plank.desktop"
  "$HOME/.local/share/applications/tint2.desktop"
  "$HOME/.local/share/applications/tint2conf.desktop"
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
  "$HOME/.config/autostart/guake.desktop"
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

ensure_openbox_session() {
# Ensure the Openbox session identifies itself as "OPENBOX", so that
# XDG_CURRENT_DESKTOP returns "OPENBOX". This enables desktop-specific
# integration such as OnlyShowIn=OPENBOX in application launchers.
    local session_file="/usr/share/xsessions/openbox.desktop"

    if [[ ! -f "$session_file" ]]; then
        log "Warning: Openbox session file not found:"
        log "  $session_file"
        return 0
    fi

    if grep -q '^DesktopNames=OPENBOX;' "$session_file"; then
        log "Openbox session already identifies as OPENBOX."
        return 0
    fi

    log "Adding DesktopNames=OPENBOX to Openbox session..."

    sudo sed -i \
        '/^Type=Application$/a DesktopNames=OPENBOX;' \
        "$session_file"
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

# --------------------------------------------------
# Detect package state before installation
# --------------------------------------------------

NEW_PACKAGES=()
OLD_PACKAGES=()

for pkg in "${CORE_PACKAGES[@]}"; do
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
sudo apt install -y "${CORE_PACKAGES[@]}"

# --------------------------------------------------
# Install optional packages & update package state
# --------------------------------------------------

log
printf "Install optional packages? [Y/n]: "
read -r answer

case "$answer" in
    ""|y|Y|yes|YES)
        log "Installing optional packages..."

        for pkg in "${OPTIONAL_PACKAGES[@]}"; do
            if is_installed "$pkg"; then
                OLD_PACKAGES+=("$pkg")
            else
                NEW_PACKAGES+=("$pkg")
            fi
        done

        sudo apt install -y "${OPTIONAL_PACKAGES[@]}"
        ;;
    *)
        log "Optional packages skipped."
        ;;
esac

# --------------------------------------------------
# Download and extract workstation configuration
# --------------------------------------------------

log
log "Downloading Openbox Workstation repository..."
curl -fL "$CONFIG_URL" -o "$WORKDIR/openbox-workstation.zip"

log "Extracting repository..."
unzip -q "$WORKDIR/openbox-workstation.zip" -d "$WORKDIR"

REPO_ROOT="$(find "$WORKDIR" -mindepth 1 -maxdepth 1 -type d | head -n1)"
CONFIG_SOURCE="$REPO_ROOT/payload"

if [ ! -d "$CONFIG_SOURCE" ]; then
    log "ERROR: Repository payload directory not found:"
    log "  $CONFIG_SOURCE"
    exit 1
fi

# --------------------------------------------------
# Create rollback snapshot (useful for users)
# --------------------------------------------------

ROLLBACK_COMPLETE="$ROLLBACK_DIR/.complete"

log
if [ -f "$ROLLBACK_COMPLETE" ]; then
    log "Existing rollback snapshot found; preserving it."
else
    log "Creating rollback snapshot..."
    rm -rf "$ROLLBACK_DIR"
    mkdir -p "$ROLLBACK_DIR"

    for path in \
        "${CONFIG_TARGETS[@]}" \
        "${OPENBOX_LAUNCHERS[@]}" \
        "${SHARED_ASSETS[@]}" \
        "${USER_AUTOSTART_OVERRIDES[@]}"; do
        copy_to_rollback "$path"
    done

    touch "$ROLLBACK_COMPLETE"
    log "Rollback snapshot completed."
fi

# --------------------------------------------------
# Install workstation configuration
# --------------------------------------------------

log
log "Installing workstation configuration..."
cp -a "$CONFIG_SOURCE/." "$HOME/"

# --------------------------------------------------
# Configure Openbox session identity
# --------------------------------------------------

log
log "Configuring Openbox session identity..."
ensure_openbox_session

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

[Openbox-Specific Application Launchers]
EOF

for path in "${OPENBOX_LAUNCHERS[@]}"; do
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

[Openbox Session Configuration]
Processed:
  /usr/share/xsessions/openbox.desktop

Required entry:
  DesktopNames=OPENBOX;
EOF

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

