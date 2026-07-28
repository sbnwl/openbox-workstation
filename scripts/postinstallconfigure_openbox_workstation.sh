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
# obmenu configuration (ref: rt-click context menu)
#--------------------------------------------------

# The code architecture is given below.
#
#    configure_obmenu()
#    │
#    ├── detect_file_manager()
#    │      │
#    │      ├── FILE_MANAGER_NAME
#    │      └── FILE_MANAGER_CMD
#    │
#    ├── detect_web_browser()
#    │      │
#    │      ├── WEB_BROWSER_NAME
#    │      └── WEB_BROWSER_CMD
#    │
#    ├── detect_terminal_emulator()
#    │      │
#    │      ├── TERMINAL_NAME
#    │      └── TERMINAL_CMD
#    │
#    └── patch_obmenu_xml()
#           │
#           └── Patch ~/.config/openbox/menu.xml
#                  ├── DEFAULT_FILE_MANAGER_CMD  → FILE_MANAGER_CMD
#                  ├── DEFAULT_WEB_BROWSER_CMD   → WEB_BROWSER_CMD
#                  └── DEFAULT_TERMINAL_CMD      → TERMINAL_CMD

# Canonical menu commands (payload defaults in menu.xml)
DEFAULT_FILE_MANAGER_CMD='nautilus --no-desktop --new-window'
DEFAULT_WEB_BROWSER_CMD='firefox "www.google.com"'
DEFAULT_TERMINAL_CMD='gnome-terminal'

detect_file_manager() {
	FILE_MANAGER_NAME=""
	FILE_MANAGER_CMD=""

	# The configuration works under order of priority of if...fi statements below.

	if command -v nautilus >/dev/null 2>&1; then
		FILE_MANAGER_NAME="nautilus"
		FILE_MANAGER_CMD="nautilus --no-desktop --new-window"
		return 0
	fi

	if command -v nemo >/dev/null 2>&1; then
		FILE_MANAGER_NAME="nemo"
		FILE_MANAGER_CMD="nemo"
		return 0
	fi

	if command -v dolphin >/dev/null 2>&1; then
		FILE_MANAGER_NAME="dolphin"
		FILE_MANAGER_CMD="dolphin --new-window"
		return 0
	fi

	if command -v thunar >/dev/null 2>&1; then
		FILE_MANAGER_NAME="thunar"
		FILE_MANAGER_CMD="thunar"
		return 0
	fi

	if command -v caja >/dev/null 2>&1; then
		FILE_MANAGER_NAME="caja"
		FILE_MANAGER_CMD="caja"
		return 0
	fi

	if command -v pcmanfm >/dev/null 2>&1; then
		FILE_MANAGER_NAME="pcmanfm"
		FILE_MANAGER_CMD="pcmanfm"
		return 0
	fi

	return 1
}

detect_web_browser() {
	WEB_BROWSER_NAME=""
	WEB_BROWSER_CMD=""

	# The configuration works under order of priority of if...fi statements below.

	if command -v firefox >/dev/null 2>&1; then
		WEB_BROWSER_NAME="firefox"
		WEB_BROWSER_CMD="firefox www.google.com"
		return 0
	fi

	if command -v microsoft-edge-stable >/dev/null 2>&1; then
		WEB_BROWSER_NAME="microsoft-edge-stable"
		WEB_BROWSER_CMD="microsoft-edge-stable www.google.com"
		return 0
	fi

	if command -v google-chrome-stable >/dev/null 2>&1; then
		WEB_BROWSER_NAME="google-chrome-stable"
		WEB_BROWSER_CMD="google-chrome-stable www.google.com"
		return 0
	fi

	if command -v brave-browser-stable >/dev/null 2>&1; then
		WEB_BROWSER_NAME="brave-browser-stable"
		WEB_BROWSER_CMD="brave-browser-stable www.google.com"
		return 0
	fi

	return 1
}

detect_terminal_emulator() {
	TERMINAL_NAME=""
	TERMINAL_CMD=""

	# The configuration works under order of priority of if...fi statements below.

	if command -v ptyxis >/dev/null 2>&1; then
		TERMINAL_NAME="ptyxis"
		TERMINAL_CMD="ptyxis"
		return 0
	fi

	if command -v gnome-terminal >/dev/null 2>&1; then
		TERMINAL_NAME="gnome-terminal"
		TERMINAL_CMD="gnome-terminal"
		return 0
	fi

	if command -v konsole >/dev/null 2>&1; then
		TERMINAL_NAME="konsole"
		TERMINAL_CMD="konsole"
		return 0
	fi

	if command -v terminator >/dev/null 2>&1; then
		TERMINAL_NAME="terminator"
		TERMINAL_CMD="terminator"
		return 0
	fi

	if command -v xfce4-terminal >/dev/null 2>&1; then
		TERMINAL_NAME="xfce4-terminal"
		TERMINAL_CMD="xfce4-terminal"
		return 0
	fi

	if command -v lxterminal >/dev/null 2>&1; then
		TERMINAL_NAME="lxterminal"
		TERMINAL_CMD="lxterminal"
		return 0
	fi

	return 1
}

patch_obmenu_xml() {
	local menu_file="$HOME/.config/openbox/menu.xml"

	if [ ! -f "$menu_file" ]; then
		echo "Error: $menu_file not found."
		return 1
	fi

	sed -i \
		-e "s|$DEFAULT_FILE_MANAGER_CMD|$FILE_MANAGER_CMD|g" \
		-e "s|$DEFAULT_WEB_BROWSER_CMD|$WEB_BROWSER_CMD|g" \
		-e "s|$DEFAULT_TERMINAL_CMD|$TERMINAL_CMD|g" \
		"$menu_file"
}

configure_obmenu() {
	detect_file_manager
	detect_web_browser
	detect_terminal_emulator
	patch_obmenu_xml
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
#    ├── detect_timezone()
#    │      │
#    │      └── TIMEZONE
#    │
#    ├── detect_weather_location()
#    │      │
#    │      ├── CITY
#    │      ├── REGION
#    │      ├── COUNTRY
#    │      ├── LAT
#    │      ├── LON
#    │      └── TIMEZONE (updated from detected location)
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

# Canonical .conkyrc defaults
DEFAULT_ETHERNET_IFACE='enp0s3'
DEFAULT_WIFI_IFACE='wlp0s20f3'

# Canonical conky weather defaults
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
}

detect_timezone() {
	TIMEZONE=""

	if command -v timedatectl >/dev/null 2>&1; then
		TIMEZONE="$(timedatectl show --property=Timezone --value)"
	fi

	if [ -z "$TIMEZONE" ] && [ -L /etc/localtime ]; then
		TIMEZONE="$(readlink /etc/localtime | sed 's|.*/zoneinfo/||')"
	fi

	[ -n "$TIMEZONE" ]
}

detect_weather_location() {
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

confirm_weather_location() {

	get_lat_lon_from_user() {

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
		echo "(Otherwise, press Enter to keep the current value)."
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
			reverse_geocode_location
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
	detect_timezone
	detect_weather_location
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

	sudo sed -i \
		-e "s|^background=.*|background=$default_background|" \
		"$theme_conf"
}

configure_sddm() {
	echo "Configuring SDDM..."

	patch_sddm_theme

	echo "SDDM successfully configured."
}

configure_sddm

#--------------------------------------------------
# Picom configuration
#--------------------------------------------------

configure_picom() {
	:
}

#--------------------------------------------------
# Main
#--------------------------------------------------

main() {
	configure_obmenu
	configure_conky
	configure_sddm
}

main
