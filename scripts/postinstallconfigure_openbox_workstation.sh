#!/bin/bash

# Openbox Workstation
# Copyright (C) 2026 Surendra Beniwal
# Author Email: surendra_beniwal@yahoo.co.in
# SPDX-License-Identifier: GPL-3.0-or-later
#
# Post-install configuration utility.
#
# Responsibilities:
#   - Detect installed applications.
#   - Customize menu.xml.
#   - Configure desktop components after installation.
#   - Apply system-specific compatibility fixes.
#
# This script is intended to be executed once by
# install_openbox_workstation.sh after all files
# have been installed.

#--------------------------------------------------
# GLOBAL FUNCTION DEFINITIONS
#--------------------------------------------------

detect_terminal_emulator() {

	local MISSING_APP_WARNING='zenity --warning --title="Application not installed" --text="No terminal emulator installed.\n\nPlease install ptyxis, terminator or another terminal app."'

	# The 'command name' (*_NAME) and 'executable string' (*_EXEC) pair

	TERMINAL_EMULATOR_NAME=""
	TERMINAL_EMULATOR_EXEC=""

	# The configuration works under order of priority of if...fi statements below.

	if command -v ptyxis >/dev/null 2>&1; then
		TERMINAL_EMULATOR_NAME="ptyxis"
		TERMINAL_EMULATOR_EXEC="ptyxis --new-window"
		return 0
	fi

	if command -v gnome-terminal >/dev/null 2>&1; then
		TERMINAL_EMULATOR_NAME="gnome-terminal"
		TERMINAL_EMULATOR_EXEC="gnome-terminal"
		return 0
	fi

	if command -v konsole >/dev/null 2>&1; then
		TERMINAL_EMULATOR_NAME="konsole"
		TERMINAL_EMULATOR_EXEC="konsole"
		return 0
	fi

	if command -v alacritty >/dev/null 2>&1; then
		TERMINAL_EMULATOR_NAME="alacritty"
		TERMINAL_EMULATOR_EXEC="alacritty"
		return 0
	fi

	if command -v terminator >/dev/null 2>&1; then
		TERMINAL_EMULATOR_NAME="terminator"
		TERMINAL_EMULATOR_EXEC="terminator"
		return 0
	fi

	if command -v xfce4-terminal >/dev/null 2>&1; then
		TERMINAL_EMULATOR_NAME="xfce4-terminal"
		TERMINAL_EMULATOR_EXEC="xfce4-terminal"
		return 0
	fi

	if command -v lxterminal >/dev/null 2>&1; then
		TERMINAL_EMULATOR_NAME="lxterminal"
		TERMINAL_EMULATOR_EXEC="lxterminal"
		return 0
	fi

	if command -v tilix >/dev/null 2>&1; then
		TERMINAL_EMULATOR_NAME="tilix"
		TERMINAL_EMULATOR_EXEC="tilix"
		return 0
	fi

	TERMINAL_EMULATOR_EXEC="$MISSING_APP_WARNING"

	return 1
}

detect_file_manager() {

	local MISSING_APP_WARNING='zenity --warning --title="Application not installed" --text="No file manager installed.\n\nPlease install thunar, nemo or another file manager app."'

	FILE_MANAGER_NAME=""
	FILE_MANAGER_EXEC=""

	# The configuration works under order of priority of if...fi statements below.

	if command -v nautilus >/dev/null 2>&1; then
		FILE_MANAGER_NAME="nautilus"
		FILE_MANAGER_EXEC="nautilus --no-desktop --new-window"
		return 0
	fi

	if command -v nemo >/dev/null 2>&1; then
		FILE_MANAGER_NAME="nemo"
		FILE_MANAGER_EXEC="nemo"
		return 0
	fi

	if command -v dolphin >/dev/null 2>&1; then
		FILE_MANAGER_NAME="dolphin"
		FILE_MANAGER_EXEC="dolphin --new-window"
		return 0
	fi

	if command -v thunar >/dev/null 2>&1; then
		FILE_MANAGER_NAME="thunar"
		FILE_MANAGER_EXEC="thunar"
		return 0
	fi

	if command -v caja >/dev/null 2>&1; then
		FILE_MANAGER_NAME="caja"
		FILE_MANAGER_EXEC="caja"
		return 0
	fi

	if command -v pcmanfm >/dev/null 2>&1; then
		FILE_MANAGER_NAME="pcmanfm"
		FILE_MANAGER_EXEC="pcmanfm"
		return 0
	fi

	FILE_MANAGER_EXEC="$MISSING_APP_WARNING"

	return 1
}

detect_web_browser() {

	local MISSING_APP_WARNING='zenity --warning --title="Application not installed" --text="No web browser installed.\n\nPlease install Firefox, Chrome, Edge or another web browser."'

	WEB_BROWSER_NAME=""
	WEB_BROWSER_EXEC=""

	# The configuration works under order of priority of if...fi statements below.

	if command -v firefox >/dev/null 2>&1; then
		WEB_BROWSER_NAME="firefox"
		WEB_BROWSER_EXEC="firefox www.google.com"
		return 0
	fi

	if command -v microsoft-edge-stable >/dev/null 2>&1; then
		WEB_BROWSER_NAME="microsoft-edge-stable"
		WEB_BROWSER_EXEC="microsoft-edge-stable www.google.com"
		return 0
	fi

	if command -v google-chrome-stable >/dev/null 2>&1; then
		WEB_BROWSER_NAME="google-chrome-stable"
		WEB_BROWSER_EXEC="google-chrome-stable www.google.com"
		return 0
	fi

	if command -v brave-browser-stable >/dev/null 2>&1; then
		WEB_BROWSER_NAME="brave-browser-stable"
		WEB_BROWSER_EXEC="brave-browser-stable www.google.com"
		return 0
	fi

	WEB_BROWSER_EXEC="$MISSING_APP_WARNING"

	return 1
}

detect_text_editor() {

	local MISSING_APP_WARNING='zenity --warning --title="Application not installed" --text="No text editor installed.\n\nPlease install gedit, geany or another text editor app."'

	TEXT_EDITOR_NAME=""
	TEXT_EDITOR_EXEC=""

	# The configuration works under order of priority of if...fi statements below.

	if command -v gnome-text-editor >/dev/null 2>&1; then
		TEXT_EDITOR_NAME="gnome-text-editor"
		TEXT_EDITOR_EXEC="gnome-text-editor"
		return 0
	fi

	if command -v gedit >/dev/null 2>&1; then
		TEXT_EDITOR_NAME="gedit"
		TEXT_EDITOR_EXEC="gedit"
		return 0
	fi

	if command -v kate >/dev/null 2>&1; then
		TEXT_EDITOR_NAME="kate"
		TEXT_EDITOR_EXEC="kate"
		return 0
	fi

	if command -v geany >/dev/null 2>&1; then
		TEXT_EDITOR_NAME="geany"
		TEXT_EDITOR_EXEC="geany"
		return 0
	fi

	if command -v xed >/dev/null 2>&1; then
		TEXT_EDITOR_NAME="xed"
		TEXT_EDITOR_EXEC="xed"
		return 0
	fi

	if command -v mousepad >/dev/null 2>&1; then
		TEXT_EDITOR_NAME="mousepad"
		TEXT_EDITOR_EXEC="mousepad"
		return 0
	fi

	if command -v featherpad >/dev/null 2>&1; then
		TEXT_EDITOR_NAME="featherpad"
		TEXT_EDITOR_EXEC="featherpad"
		return 0
	fi

	if command -v leafpad >/dev/null 2>&1; then
		TEXT_EDITOR_NAME="leafpad"
		TEXT_EDITOR_EXEC="leafpad"
		return 0
	fi

	if command -v pluma >/dev/null 2>&1; then
		TEXT_EDITOR_NAME="pluma"
		TEXT_EDITOR_EXEC="pluma"
		return 0
	fi

	TEXT_EDITOR_EXEC="$MISSING_APP_WARNING"

	return 1
}

detect_lock_screen() {

	local MISSING_APP_WARNING='zenity --warning --title="Application not installed" --text="No screen locking utility installed.\n\nPlease install dm-tool, gnome-screensaver or another utility."'

	LOCK_SCREEN_NAME=""
	LOCK_SCREEN_EXEC=""

	# The configuration works under order of priority of if...fi statements below.

	if command -v gnome-screensaver-command >/dev/null 2>&1; then
		LOCK_SCREEN_NAME="gnome-screensaver-command"
		LOCK_SCREEN_EXEC="gnome-screensaver-command --lock"
		return 0
	fi

	if command -v dm-tool >/dev/null 2>&1; then
		LOCK_SCREEN_NAME="dm-tool"
		LOCK_SCREEN_EXEC="dm-tool lock"
		return 0
	fi

	if command -v slock-secure-lock >/dev/null 2>&1; then
		LOCK_SCREEN_NAME="slock-secure-lock"
		LOCK_SCREEN_EXEC="slock-secure-lock"
		return 0
	fi

	LOCK_SCREEN_EXEC="$MISSING_APP_WARNING"

	return 1
}

detect_scrRes_tool() {

	local MISSING_APP_WARNING='zenity --warning --title="Application not installed" --text="No screen resolution handling utility installed.\n\nPlease install arandr or similar utility."'

	SCREEN_RES_NAME=""
	SCREEN_RES_EXEC=""

	# Detect screen resolution handling tool
	# The configuration works under order of priority of if...fi statements below.

	if command -v arandr >/dev/null 2>&1; then
		SCREEN_RES_NAME="arandr"
		SCREEN_RES_EXEC="arandr"
		return 0
	fi

	SCREEN_RES_EXEC="$MISSING_APP_WARNING"

	return 1
}

#--------------------------------------------------
# obmenu configuration (ref: rt-click context menu)
#--------------------------------------------------

# The code architecture is given below.
#
#    configure_obmenu()
#    │
#    ├── detect_file_manager()
#    │      │
#    │      ├── FILE_MANAGER_NAME
#    │      └── FILE_MANAGER_EXEC
#    │
#    ├── detect_web_browser()
#    │      │
#    │      ├── WEB_BROWSER_NAME
#    │      └── WEB_BROWSER_EXEC
#    │
#    ├── detect_terminal_emulator()
#    │      │
#    │      ├── TERMINAL_EMULATOR_NAME
#    │      └── TERMINAL_EMULATOR_EXEC
#    │
#    └── patch_obmenu_xml()
#           │
#           └── Patch ~/.config/openbox/menu.xml
#                  ├── DEFAULT_TERMINAL_EMULATOR_EXEC 	→ TERMINAL_EMULATOR_EXEC
#                  ├── DEFAULT_FILE_MANAGER_EXEC 		→ FILE_MANAGER_EXEC
#                  └── DEFAULT_WEB_BROWSER_EXEC 		→ WEB_BROWSER_EXEC

# Canonical menu commands (Note: synchronise with default menu.xml in payload)

patch_obmenu_xml() {

	local menu_file="$HOME/.config/openbox/menu.xml"

	[[ -f "$menu_file" ]] || {
		echo "Error: $menu_file not found."
		return 1
	}

	local label exec_string
	# Caution: The exec_string must never contain & or |

	# Replace the label with executable string
	while IFS='|' read -r label exec_string; do

		[[ -z "$label" || "$label" =~ ^# ]] && continue

		sed -i \
			"/<item label=\"$label\">/,/<\/item>/ \
			s|<execute>[^<]*</execute>|<execute>$exec_string</execute>|" \
			"$menu_file"
	done <<EOF
# Here is the routing table
Terminal emulator|$TERMINAL_EMULATOR_EXEC
File manager|$FILE_MANAGER_EXEC
Web browser|$WEB_BROWSER_EXEC
ObAutostart|$TEXT_EDITOR_NAME ~/.config/openbox/autostart
Lock Screen|$LOCK_SCREEN_EXEC
Screen Resolution|$SCREEN_RES_EXEC
EOF
}

configure_obmenu() {

	detect_terminal_emulator
	detect_file_manager
	detect_web_browser
	detect_text_editor
	detect_lock_screen
	detect_scrRes_tool
	patch_obmenu_xml
}

#--------------------------------------------------
# XFCE4 configuration
#--------------------------------------------------

patch_xfce4_launchers() {

	local launcher_files

	echo "  Configuring XFCE4 launchers..."

	local panel_dir="$HOME/.config/xfce4/panel"
	local filemanager_launcher browser_launcher

	launcher_files=("$panel_dir/launcher-2/"*.desktop)
	filemanager_launcher="${launcher_files[0]}"

	launcher_files=("$panel_dir/launcher-3/"*.desktop)
	browser_launcher="${launcher_files[0]}"

	if [[ -f "$filemanager_launcher" ]]; then
		sed -i \
			"s|^Exec=.*|Exec=$FILE_MANAGER_EXEC|" \
			"$filemanager_launcher"

		echo "  File manager launcher configured."
	fi

	if [[ -f "$browser_launcher" ]]; then
		sed -i \
			"s|^Exec=.*|Exec=$WEB_BROWSER_EXEC|" \
			"$browser_launcher"

		echo "  Web browser launcher configured."
	fi
}

configure_xfce4() {

	echo "Configuring XFCE4..."

	detect_file_manager
	detect_web_browser
	patch_xfce4_launchers

	echo "XFCE4 successfully configured."
}

#--------------------------------------------------
# conky configuration (ref: desktop information)
#--------------------------------------------------

# The code architecture is given below.
#
#    configure_conky()
#    │
#    ├── detect_network_interfaces()
#    │      │
#    │      ├── ETHERNET_IFACE
#    │      └── WIFI_IFACE
#    │
#    ├── detect_user_timezone()
#    │      │
#    │      └── TIMEZONE
#    │
#    ├── detect_user_weather_location()
#    │      │
#    │      ├── CITY
#    │      ├── REGION
#    │      ├── COUNTRY
#    │      ├── LAT
#    │      ├── LON
#    │      └── TIMEZONE (updated from detected location)
#    ├── load_existing_weather_location()
#    │              │
#    │              ├── EXISTING_CITY
#    │              ├── EXISTING_REGION
#    │              ├── EXISTING_COUNTRY
#    │              ├── EXISTING_LAT
#    │              ├── EXISTING_LON
#    │              └── EXISTING_TIMEZONE
#    │
#    ├── confirm_weather_location()
#    │      │
#    │      ├── 1) Use detected location
#    │      │      └── Variables unchanged
#    │      │
#    │      ├── 2) Keep payload defaults
#    │      │      └── Variables ← DEFAULT_*
#    │      │
#    │      └── 3) Enter location manually
#    │             │
#    │             ├── get_lat_lon_from_user()
#    │             │      └── LAT, LON
#    │             │
#    │             └── reverse_geocode_location()
#    │                  │
#    │                  ├── parse_nominatim_location_json()
#    │                  ├── CITY
#    │                  │      ├── REGION
#    │                  │      └── COUNTRY
#    │                  │
#    │                  └── detect_timezone_from_coords()
#    │                         └── TIMEZONE
#    │
#    └── patch_conky_files()
#        │
#        ├── Patch ~/.conkyrc
#        │      ├── ETHERNET_IFACE
#        │      └── WIFI_IFACE
#        │
#        └── Patch conky-weather-fetch.sh
#              ├── CITY
#              ├── REGION
#              ├── COUNTRY
#              ├── LAT
#              ├── LON
#              └── TIMEZONE

# Canonical .conkyrc config (Note: synchronise with default .conkyrc in payload)
DEFAULT_ETHERNET_IFACE='enp0s3'
DEFAULT_WIFI_IFACE='wlp0s20f3'

# Canonical conky weather defaults (Note: synchronise with conky-weather-fetch.sh in payload)
DEFAULT_CITY="Kolkata"
DEFAULT_REGION="West Bengal"
DEFAULT_COUNTRY="India"
DEFAULT_LAT="22.5726"
DEFAULT_LON="88.3639"
DEFAULT_TIMEZONE="Asia/Kolkata"

parse_ipapi_location_json() {

	local json_string="$1"

	CITY=$(printf '%s' "$json_string" | jq -r '.city')
	REGION=$(printf '%s' "$json_string" | jq -r '.region')
	COUNTRY=$(printf '%s' "$json_string" | jq -r '.country_name')
	LAT=$(printf '%s' "$json_string" | jq -r '.latitude')
	LON=$(printf '%s' "$json_string" | jq -r '.longitude')
	TIMEZONE=$(printf '%s' "$json_string" | jq -r '.timezone')

	[ "$CITY" = "null" ] && CITY=""
	[ "$REGION" = "null" ] && REGION=""
	[ "$COUNTRY" = "null" ] && COUNTRY=""
	[ "$LAT" = "null" ] && LAT=""
	[ "$LON" = "null" ] && LON=""
	[ "$TIMEZONE" = "null" ] && TIMEZONE=""
}

parse_nominatim_location_json() {

	local json_string="$1"

	CITY="$(printf '%s' "$json_string" | jq -r \
		'.address.city
        // .address.town
        // .address.village
        // .address.hamlet
        // .address.suburb
        // empty')"

	REGION="$(printf '%s' "$json_string" | jq -r \
		'.address.state
        // .address.state_district
        // empty')"

	COUNTRY="$(printf '%s' "$json_string" | jq -r \
		'.address.country
        // empty')"

	[ "$CITY" = "null" ] && CITY=""
	[ "$REGION" = "null" ] && REGION=""
	[ "$COUNTRY" = "null" ] && COUNTRY=""
}

detect_network_interfaces() {

	WIFI_IFACE=""
	ETHERNET_IFACE=""

	local iface

	for iface in /sys/class/net/*; do
		iface="${iface##*/}"

		# Ignore loopback
		[ "$iface" = "lo" ] && continue

		# Record only the first interface of each type
		if [ -d "/sys/class/net/$iface/wireless" ]; then
			[ -z "$WIFI_IFACE" ] && WIFI_IFACE="$iface"
		else
			[ -z "$ETHERNET_IFACE" ] && ETHERNET_IFACE="$iface"
		fi
	done

	# Fallback to defaults if no interfaces were detected
	WIFI_IFACE="${WIFI_IFACE:-$DEFAULT_WIFI_IFACE}"
	ETHERNET_IFACE="${ETHERNET_IFACE:-$DEFAULT_ETHERNET_IFACE}"
}

detect_user_timezone() {

	TIMEZONE=""

	if command -v timedatectl >/dev/null 2>&1; then
		TIMEZONE="$(timedatectl show --property=Timezone --value)"
	fi

	if [ -z "$TIMEZONE" ] && [ -L /etc/localtime ]; then
		TIMEZONE="$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')"
	fi

	[ -n "$TIMEZONE" ]
}

detect_user_weather_location() {

	CITY="$DEFAULT_CITY"
	REGION="$DEFAULT_REGION"
	COUNTRY="$DEFAULT_COUNTRY"
	LAT="$DEFAULT_LAT"
	LON="$DEFAULT_LON"
	TIMEZONE="$DEFAULT_TIMEZONE"

	local json_string

	json_string="$(curl -fsSL --connect-timeout 5 https://ipapi.co/json/ 2>/dev/null)" || return 0

	parse_ipapi_location_json "$json_string"

	return 0
}

load_existing_weather_location() {

	# Load the weather location currently configured in the installed
	# Conky weather script. These values are presented as the defaults
	# when the user chooses to enter coordinates manually.

	local WEATHER_SCRIPT="$HOME/.conky-google-now/conky-weather-fetch.sh"

	if [ ! -f "$WEATHER_SCRIPT" ]; then
		return 0
	fi

	EXISTING_CITY=$(sed -n 's/^CITY="\([^"]*\)"/\1/p' "$WEATHER_SCRIPT")
	EXISTING_REGION=$(sed -n 's/^REGION="\([^"]*\)"/\1/p' "$WEATHER_SCRIPT")
	EXISTING_COUNTRY=$(sed -n 's/^COUNTRY="\([^"]*\)"/\1/p' "$WEATHER_SCRIPT")
	EXISTING_LAT=$(sed -n 's/^LAT="\([^"]*\)"/\1/p' "$WEATHER_SCRIPT")
	EXISTING_LON=$(sed -n 's/^LON="\([^"]*\)"/\1/p' "$WEATHER_SCRIPT")
	EXISTING_TIMEZONE=$(sed -n 's/^TIMEZONE="\([^"]*\)"/\1/p' "$WEATHER_SCRIPT")
}

confirm_weather_location() {

	load_existing_weather_location

	get_lat_lon_from_user() {

		LAT="$EXISTING_LAT"
		LON="$EXISTING_LON"

		local input

		echo
		echo "Be ready with your location coordinates."
		echo "┌──────────────────────────────────────────────────┐"
		echo "│You can obtain them from Google Maps:             │"
		echo "│  1. Open https://maps.google.com                 │"
		echo "│  2. Right-click your location.                   │"
		echo "│  3. Click the displayed coordinates to copy them.│"
		echo "│  4. Paste the latitude and longitude below.      │"
		echo "└──────────────────────────────────────────────────┘"
		echo
		echo "Enter your location coordinates."
		echo "(Press Enter to keep the existing value.)"
		echo

		while true; do
			read -rp "Latitude [$LAT]: " input

			if [ -z "$input" ]; then
				break
			elif [[ "$input" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
				LAT="$input"
				break
			else
				echo "Invalid latitude."
			fi
		done

		while true; do
			read -rp "Longitude [$LON]: " input

			if [ -z "$input" ]; then
				break
			elif [[ "$input" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]; then
				LON="$input"
				break
			else
				echo "Invalid longitude."
			fi
		done
	}

	detect_timezone_from_coords() {

		local json_string

		json_string="$(
			curl -fsSL \
				--connect-timeout 5 \
				--max-time 10 \
				-A "Openbox-Workstation/1.2" \
				"https://timeapi.io/api/TimeZone/coordinate?latitude=${LAT}&longitude=${LON}" \
				2>/dev/null
		)" || {
			echo "Unable to determine timezone from coordinates."
			return 1
		}

		TIMEZONE="$(printf '%s' "$json_string" | jq -r '.timeZone // empty')"

		if [ -z "$TIMEZONE" ]; then
			echo "Timezone lookup failed."
			return 1
		fi

		return 0
	}

	reverse_geocode_location() {

		local json_string

		json_string="$(
			curl -fsSL \
				--connect-timeout 5 \
				--max-time 10 \
				-A "Openbox-Workstation/1.2" \
				"https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${LAT}&lon=${LON}" \
				2>/dev/null
		)" || {
			echo "Unable to contact the reverse geocoding service."
			return 1
		}

		if printf '%s' "$json_string" | jq -e '.error' >/dev/null 2>&1; then
			echo "Reverse geocoding failed."
			return 1
		fi

		parse_nominatim_location_json "$json_string"

		detect_timezone_from_coords || return 1
	}

	local choice

	while true; do
		echo
		echo "Weather location:"
		echo
		echo "  City      : $CITY"
		echo "  Region    : $REGION"
		echo "  Country   : $COUNTRY"
		echo "  Latitude  : $LAT"
		echo "  Longitude : $LON"
		echo
		echo "Choose an option:"
		echo "  1) Use detected location"
		echo "  2) Keep payload defaults"
		echo "  3) Enter location manually"
		echo

		read -rp "Selection [1-3]: " choice

		case "$choice" in
		1)
			return
			;;

		2)
			CITY="$DEFAULT_CITY"
			REGION="$DEFAULT_REGION"
			COUNTRY="$DEFAULT_COUNTRY"
			LAT="$DEFAULT_LAT"
			LON="$DEFAULT_LON"
			TIMEZONE="$DEFAULT_TIMEZONE"
			return
			;;

		3)
			get_lat_lon_from_user
			reverse_geocode_location || {
				echo "Unable to determine location details."
				echo "Existing values will be retained."
			}
			return
			;;

		*)
			echo "Invalid selection. Please enter 1, 2 or 3."
			;;
		esac
	done
}

patch_conky_files() {

	local conkyrc="$HOME/.conkyrc"
	local weather_script="$HOME/.conky-google-now/conky-weather-fetch.sh"

	#--------------------------------------------------
	# Patch .conkyrc
	#--------------------------------------------------

	if [ -f "$conkyrc" ]; then
		echo "  Patching $conkyrc"

		sed -i \
			-e "s|$DEFAULT_ETHERNET_IFACE|$ETHERNET_IFACE|g" \
			-e "s|$DEFAULT_WIFI_IFACE|$WIFI_IFACE|g" \
			"$conkyrc"
	else
		echo "  Warning: $conkyrc not found."
	fi

	#--------------------------------------------------
	# Patch weather configuration
	#--------------------------------------------------

	if [ -f "$weather_script" ]; then
		echo "  Patching $weather_script"

		sed -i \
			-e "s|^CITY=.*|CITY=\"$CITY\"|" \
			-e "s|^REGION=.*|REGION=\"$REGION\"|" \
			-e "s|^COUNTRY=.*|COUNTRY=\"$COUNTRY\"|" \
			-e "s|^LAT=.*|LAT=\"$LAT\"|" \
			-e "s|^LON=.*|LON=\"$LON\"|" \
			-e "s|^TIMEZONE=.*|TIMEZONE=\"$TIMEZONE\"|" \
			"$weather_script"
	else
		echo "  Warning: $weather_script not found."
	fi

	echo
	echo "Applied configuration:"
	echo "  Ethernet Interface : $ETHERNET_IFACE"
	echo "  Wi-Fi Interface    : $WIFI_IFACE"
	echo "  Timezone           : $TIMEZONE"
	echo "  City               : $CITY"
	echo "  Region             : $REGION"
	echo "  Country            : $COUNTRY"
	echo "  Latitude           : $LAT"
	echo "  Longitude          : $LON"
}

configure_conky() {

	echo "Configuring Conky..."

	detect_network_interfaces
	detect_user_timezone
	detect_user_weather_location
	confirm_weather_location
	patch_conky_files
	echo "$TIMEZONE" >"$HOME/.conky-google-now/timezone"

	echo "Conky successfully configured."
}

#--------------------------------------------------
# SDDM configuration
#--------------------------------------------------

# The code architecture is given below.
#
#    configure_sddm()
#    │
#    └── patch_sddm_theme()
#           │
#           └── Replace broken background path

patch_sddm_theme() {

	local theme_conf="/usr/share/sddm/themes/ubuntu-budgie-login/theme.conf"
	local default_background="/usr/share/sddm/themes/ubuntu-budgie-login/backgrounds/default.jpg"
	local backup="${theme_conf}.bak"

	if [ ! -f "$theme_conf" ]; then
		echo "  SDDM theme not found. Skipping."
		return 0
	fi

	if [ ! -f "$default_background" ]; then
		echo "  Default SDDM background not found."
		return 1
	fi

	# Create backup only once
	if [ ! -f "$backup" ]; then
		echo "  Backing up $theme_conf"
		sudo cp "$theme_conf" "$backup"
	fi

	echo "  Patching $theme_conf"

	sudo sed -i -E \
		-e "s|^(background[[:space:]]*=[[:space:]]*).*|\1\"$default_background\"|" \
		"$theme_conf"
}

configure_sddm() {

	echo "Configuring SDDM..."

	patch_sddm_theme

	echo "SDDM successfully configured."
}

#--------------------------------------------------
# Picom configuration
#--------------------------------------------------

configure_picom() {

	:
}

#--------------------------------------------------
# App configuration
#--------------------------------------------------

hide_desktop_entries() {

	local list_file="$HOME/.config/obdesktop/hidden-desktop-entries.list"
	local system_dir="/usr/share/applications"
	local user_dir="$HOME/.local/share/applications"

	[[ -f "$list_file" ]] || {
		echo "Hidden desktop entries list not found: $list_file"
		return
	}

	mkdir -p "$user_dir"

	while IFS= read -r entry; do
		# Skip blank lines and comments
		[[ -z "$entry" || "$entry" =~ ^[[:space:]]*# ]] && continue

		local system_entry="$system_dir/$entry"
		local user_entry="$user_dir/$entry"

		# Skip if the desktop entry is not installed
		[[ -f "$system_entry" ]] || continue

		[[ -f "$user_entry" ]] || cp "$system_entry" "$user_entry"

		if grep -q '^NoDisplay=' "$user_entry"; then
			sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$user_entry"
		else
			printf '\nNoDisplay=true\n' >>"$user_entry"
		fi

	done <"$list_file"

	update-desktop-database "$user_dir" >/dev/null 2>&1 || true

	echo "  Selected desktop entries hidden."
}

configure_apps() {

	echo "Configuring apps..."

	hide_desktop_entries

	echo "Apps successfully configured."
}

#--------------------------------------------------
# Main
#--------------------------------------------------

main() {

	configure_obmenu
	configure_xfce4
	configure_conky
	configure_sddm
	configure_apps
}

main
