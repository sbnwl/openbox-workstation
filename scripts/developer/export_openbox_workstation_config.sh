#!/usr/bin/env bash

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

copy_if_exists "$HOME/.gtkrc-2.0"
copy_if_exists "$HOME/.conkyrc"
copy_if_exists "$HOME/.compton.conf"
copy_if_exists "$HOME/WELCOME.txt"

copy_if_exists "$HOME/.local/share/applications/AppearanceTheme.desktop"
copy_if_exists "$HOME/.local/share/applications/Conky.desktop"

copy_if_exists "$HOME/.local/share/fonts/raleway-elementary"
copy_if_exists "$HOME/.local/share/fonts/open-sans"

copy_if_exists "$HOME/.local/share/themes/Mistral-Thin"

copy_if_exists "$HOME/.conky-google-now"

copy_if_exists "$HOME/.config/picom"
copy_if_exists "$HOME/.config/xfce4"
copy_if_exists "$HOME/.config/tint2"
copy_if_exists "$HOME/.config/plank"
copy_if_exists "$HOME/.config/jgmenu"
copy_if_exists "$HOME/.config/openbox"

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
