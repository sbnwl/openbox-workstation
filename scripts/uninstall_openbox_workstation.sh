#!/usr/bin/env bash

set -euo pipefail

PROJECT_NAME="Openbox Workstation"
PROJECT_SLUG="openbox-workstation"
VERSION="1.1"
STATE_DIR="$HOME/.local/share/openbox-workstation"
LOG_DIR="$STATE_DIR/logs"

LOG_FILE="$LOG_DIR/uninstall.log"
MANIFEST="$STATE_DIR/install-manifest"
ROLLBACK_DIR="$STATE_DIR/rollback"

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

USER_AUTOSTART_OVERRIDES=(
  "$HOME/.config/autostart/blueman.desktop"
  "$HOME/.config/autostart/nm-applet.desktop"
)

mkdir -p "$LOG_DIR"
: > "$LOG_FILE"

log() {
    echo "$@" | tee -a "$LOG_FILE"
}

restore_from_rollback() {
    if [ -d "$ROLLBACK_DIR" ]; then
        cp -a "$ROLLBACK_DIR/." "$HOME/"
        log "Restored rollback snapshot."
    else
        log "No rollback snapshot found."
    fi
}

read_new_packages() {
    awk '
        /^\[Packages Newly Installed\]/ {flag=1; next}
        /^\[/ {flag=0}
        flag && NF {print}
    ' "$MANIFEST" 2>/dev/null || true
}

log "$PROJECT_NAME Uninstaller"
log "Version: $VERSION"
log "Started: $(date)"
log

if [ ! -f "$MANIFEST" ]; then
    log "Warning: install manifest not found:"
    log "$MANIFEST"
    log "The uninstaller will remove known user-level configuration only."
fi

printf "Uninstall Openbox Workstation from this user account? [y/N]: "
read -r answer

case "$answer" in
    y|Y|yes|YES)
        ;;
    *)
        log "Uninstall cancelled."
        exit 0
        ;;
esac

log
log "Removing Openbox Workstation user configuration..."

for path in "${CONFIG_TARGETS[@]}"; do
    if [ -e "$path" ]; then
        rm -rf "$path"
        log "Removed: $path"
    fi
done

log
log "Removing user-level autostart overrides..."

for path in "${USER_AUTOSTART_OVERRIDES[@]}"; do
    if [ -e "$path" ]; then
        rm -f "$path"
        log "Removed: $path"
    fi
done

log
log "Restoring previous user configuration..."
restore_from_rollback

if [ -f "$MANIFEST" ]; then
    mapfile -t NEW_PACKAGES < <(read_new_packages)

    if [ "${#NEW_PACKAGES[@]}" -gt 0 ]; then
        echo
        echo "The following packages were installed by Openbox Workstation:"
        printf '  %s\n' "${NEW_PACKAGES[@]}"
        echo
        printf "Remove these packages as well? [y/N]: "
        read -r pkg_answer

        case "$pkg_answer" in
            y|Y|yes|YES)
                if command -v apt >/dev/null 2>&1; then
                    sudo apt remove -y "${NEW_PACKAGES[@]}"
                    log "Removed packages: ${NEW_PACKAGES[*]}"
                else
                    log "Package removal skipped: apt not found."
                fi
                ;;
            *)
                log "Package removal skipped by user."
                ;;
        esac
    fi
fi

log
log "Cleaning Openbox Workstation state directory..."
rm -rf "$STATE_DIR"

echo "Openbox Workstation uninstall complete."
echo
echo "Note:"
echo "Shared fonts and themes installed in ~/.local/share were left in place."
echo "They may still be useful in other desktop environments."
