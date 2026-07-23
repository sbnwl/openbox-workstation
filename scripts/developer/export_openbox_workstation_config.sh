#!/usr/bin/env bash

# Openbox Workstation
# Copyright (C) 2026 Surendra Beniwal
# SPDX-License-Identifier: GPL-3.0-or-later
#


set -euo pipefail

PROJECT_NAME="Openbox Workstation"
PROJECT_SLUG="openbox-workstation"
VERSION="1.1"
STATE_DIR="$HOME/.local/share/openbox-workstation"
LOG_DIR="$STATE_DIR/logs"

LOG_FILE="$LOG_DIR/export.log"

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
OUTPUT_ZIP="${PROJECT_SLUG}-config-v${VERSION}-${TIMESTAMP}.zip"
WORKDIR="$(mktemp -d)"
EXPORT_ROOT="$WORKDIR/openbox-workstation-config"

mkdir -p "$LOG_DIR"
: > "$LOG_FILE"

log() {
    echo "$@" | tee -a "$LOG_FILE"
}

cleanup() {
    rm -rf "$WORKDIR"
}
trap cleanup EXIT

log "$PROJECT_NAME Export"
log "Version: $VERSION"
log "Started: $(date)"
log

if ! command -v zip >/dev/null 2>&1; then
    log
    log "ERROR: Required program 'zip' is not installed."
    log
    log "Install it using:"
    log "    sudo apt install zip"
    exit 1
fi

mkdir -p "$EXPORT_ROOT"

copy_if_exists() {
    local src="$1"
    local dest

    if [ -e "$src" ]; then
        dest="$EXPORT_ROOT/${src#$HOME/}"
        mkdir -p "$(dirname "$dest")"
        cp -a "$src" "$dest"
        log "Included: $src"
    else
        log "Skipped : $src"
    fi
}

CONFIG_TARGETS=(
  "$HOME/.gtkrc-2.0"
  "$HOME/.conkyrc"
  "$HOME/.compton.conf"
  "$HOME/WELCOME.txt"
  "$HOME/.conky-google-now"
  "$HOME/.config/picom"
  "$HOME/.config/xfce4"
  "$HOME/.config/tint2"
  "$HOME/.config/plank"
  "$HOME/.config/jgmenu"
  "$HOME/.config/openbox"
  "$HOME/.config/gtk-3.0/gtk.css"
  "$HOME/.config/gtk-3.0/settings.ini"
  "$HOME/.config/gtk-3.0/xfce4-panel-tint2.css"
  "$HOME/.xsettingsd"
)

SHARED_ASSETS=(
  "$HOME/.local/share/fonts/raleway-elementary"
  "$HOME/.local/share/fonts/open-sans"
  "$HOME/.local/share/themes/Mistral-Thin"
)

OPENBOX_LAUNCHERS=(
  "$HOME/.local/share/applications/lxappearance.desktop"
  "$HOME/.local/share/applications/conky.desktop"
  "$HOME/.local/share/applications/obconf.desktop"
  "$HOME/.local/share/applications/picom.desktop"
  "$HOME/.local/share/applications/plank.desktop"
  "$HOME/.local/share/applications/tint2.desktop"
  "$HOME/.local/share/applications/tint2conf.desktop"
)

USER_AUTOSTART_OVERRIDES=(
  "$HOME/.config/autostart/blueman.desktop"
  "$HOME/.config/autostart/nm-applet.desktop"
  "$HOME/.config/autostart/guake.desktop"
)

for path in \
    "${CONFIG_TARGETS[@]}" \
    "${SHARED_ASSETS[@]}" \
    "${OPENBOX_LAUNCHERS[@]}" \
    "${USER_AUTOSTART_OVERRIDES[@]}"
do
    copy_if_exists "$path"
done

cat > "$EXPORT_ROOT/manifest.txt" <<EOF
Openbox Workstation Configuration Export

Version: $VERSION
Created: $TIMESTAMP
Source user: $USER
Source home: $HOME

This ZIP archive is intended for use with install_openbox_workstation.sh.
EOF

(
    cd "$WORKDIR"
    zip -qr "$OLDPWD/$OUTPUT_ZIP" openbox-workstation-config
)

log
log "Finished: $(date)"
log "Export complete:"
log "$OUTPUT_ZIP"
