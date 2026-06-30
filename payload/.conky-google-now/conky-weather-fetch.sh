#!/bin/bash
# ============================================================
# conky-weather-fetch.sh
# Fetches weather data from Open-Meteo (free, no API key)
# and writes parsed values to ~/.cache/weather-data/
#
# Usage: called automatically by Conky via ${execi 300 ...}
# You can also run it manually to test:  bash conky-weather-fetch.sh
# ============================================================

# =====================================================
# USER SETTINGS — edit these to set your city
# =====================================================
CITY="Jammu"            # City name shown on Conky
REGION="Jammu and Kashmir"            # State / region name
COUNTRY="India"         # Country name
LAT="32.8028"           # Latitude  (get from maps.google.com)
LON="74.8914"           # Longitude (get from maps.google.com)
TIMEZONE="Asia/Kolkata" # Timezone  (from: timedatectl)
WIND_UNIT="km/h"        # Wind unit: km/h or mph
# =====================================================
# CITY="New Delhi"        # City name shown on Conky
# REGION="Delhi"          # State / region name
# COUNTRY="India"         # Country name
# LAT="28.6139"           # Latitude  (get from maps.google.com)
# LON="77.2090"           # Longitude (get from maps.google.com)
# TIMEZONE="Asia/Kolkata" # Timezone  (from: timedatectl)
# WIND_UNIT="km/h"        # Wind unit: km/h or mph
# =====================================================

CACHE_DIR="$HOME/.cache/weather-data"
mkdir -p "$CACHE_DIR"

# Fetch from Open-Meteo (free, no API key needed)
DATA=$(curl -s --max-time 10 \
  "https://api.open-meteo.com/v1/forecast\
?latitude=${LAT}\
&longitude=${LON}\
&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weathercode\
&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_probability_max\
&timezone=${TIMEZONE}\
&forecast_days=5\
&wind_speed_unit=kmh")

# Exit silently if fetch failed (Conky will show last cached values)
if [ -z "$DATA" ] || echo "$DATA" | grep -q "error"; then
  exit 1
fi

# Parse using python3 (available on all modern Ubuntu systems)
python3 << EOF
import json, os, sys

data = json.loads('''$DATA''')
cache = "$CACHE_DIR"

cur  = data["current"]
day  = data["daily"]

# --- Current conditions ---
temp    = int(round(cur["temperature_2m"]))
humid   = int(round(cur["relative_humidity_2m"]))
wind    = int(round(cur["wind_speed_10m"]))
wcode   = int(cur["weathercode"])

# --- WMO weather code → Yahoo-style code mapping ---
# conky-google-now icons use Yahoo codes (0-47).
# This maps WMO codes to the closest matching Yahoo icon.
WMO_TO_YAHOO = {
    0:  32,  # Clear sky          → Sunny
    1:  34,  # Mainly clear       → Fair (day)
    2:  30,  # Partly cloudy      → Partly cloudy
    3:  26,  # Overcast           → Cloudy
    45: 20,  # Fog                → Foggy
    48: 20,  # Icy fog            → Foggy
    51: 9,   # Light drizzle      → Drizzle
    53: 9,   # Moderate drizzle   → Drizzle
    55: 9,   # Dense drizzle      → Drizzle
    61: 11,  # Slight rain        → Showers
    63: 12,  # Moderate rain      → Showers
    65: 12,  # Heavy rain         → Showers
    66: 8,   # Freezing rain      → Freezing drizzle
    67: 8,   # Heavy freezing rain→ Freezing drizzle
    71: 16,  # Slight snow        → Snow
    73: 16,  # Moderate snow      → Snow
    75: 41,  # Heavy snow         → Heavy snow
    77: 18,  # Snow grains        → Sleet
    80: 11,  # Slight showers     → Showers
    81: 12,  # Moderate showers   → Showers
    82: 12,  # Violent showers    → Showers
    85: 16,  # Slight snow shower → Snow
    86: 41,  # Heavy snow shower  → Heavy snow
    95: 4,   # Thunderstorm       → Thunderstorm
    96: 4,   # Thunderstorm+hail  → Thunderstorm
    99: 4,   # Thunderstorm+hail  → Thunderstorm
}

# WMO code → human readable condition text
WMO_TO_TEXT = {
    0:  "Clear Sky",
    1:  "Mainly Clear",
    2:  "Partly Cloudy",
    3:  "Overcast",
    45: "Foggy",
    48: "Icy Fog",
    51: "Light Drizzle",
    53: "Drizzle",
    55: "Heavy Drizzle",
    61: "Light Rain",
    63: "Moderate Rain",
    65: "Heavy Rain",
    66: "Freezing Rain",
    67: "Heavy Freezing Rain",
    71: "Light Snow",
    73: "Moderate Snow",
    75: "Heavy Snow",
    77: "Snow Grains",
    80: "Light Showers",
    81: "Showers",
    82: "Heavy Showers",
    85: "Snow Showers",
    86: "Heavy Snow Showers",
    95: "Thunderstorm",
    96: "Thunderstorm & Hail",
    99: "Thunderstorm & Hail",
}

yahoo_code = WMO_TO_YAHOO.get(wcode, 3200)
condition  = WMO_TO_TEXT.get(wcode, "Not Available")

# Write current conditions
with open(f"{cache}/city",       "w") as f: f.write("$CITY")
with open(f"{cache}/region",     "w") as f: f.write("$REGION")
with open(f"{cache}/country",    "w") as f: f.write("$COUNTRY")
with open(f"{cache}/temp",       "w") as f: f.write(str(temp))
with open(f"{cache}/humidity",   "w") as f: f.write(str(humid))
with open(f"{cache}/wind",       "w") as f: f.write(str(wind))
with open(f"{cache}/wind_unit",  "w") as f: f.write("$WIND_UNIT")
with open(f"{cache}/condition",  "w") as f: f.write(condition)
with open(f"{cache}/icon_code",  "w") as f: f.write(str(yahoo_code))

# Write 5-day forecast
days_short = ["SUN","MON","TUE","WED","THU","FRI","SAT"]
import datetime
for i in range(5):
    date_str  = day["time"][i]
    dt        = datetime.date.fromisoformat(date_str)
    day_name  = days_short[dt.weekday() if dt.weekday() != 6 else 6]
    # Python weekday: 0=Mon,6=Sun — fix for Sun
    day_names = ["MON","TUE","WED","THU","FRI","SAT","SUN"]
    day_name  = day_names[dt.weekday()]

    hi        = int(round(day["temperature_2m_max"][i]))
    lo        = int(round(day["temperature_2m_min"][i]))
    fc_wcode  = int(day["weathercode"][i])
    fc_icon   = WMO_TO_YAHOO.get(fc_wcode, 3200)

    with open(f"{cache}/fc{i}_day",  "w") as f: f.write(day_name)
    with open(f"{cache}/fc{i}_hi",   "w") as f: f.write(str(hi))
    with open(f"{cache}/fc{i}_lo",   "w") as f: f.write(str(lo))
    with open(f"{cache}/fc{i}_icon", "w") as f: f.write(str(fc_icon))

    # Copy icon to cache for Conky image display
    icon_src  = os.path.expanduser(f"~/.conky-google-now/{fc_icon}.png")
    icon_dst  = f"{cache}/forecast-{i}.png"
    if os.path.exists(icon_src):
        import shutil
        shutil.copy2(icon_src, icon_dst)

# Copy current condition icon
cur_icon_src = os.path.expanduser(f"~/.conky-google-now/{yahoo_code}.png")
cur_icon_dst = f"{cache}/condition-icon.png"
if os.path.exists(cur_icon_src):
    import shutil
    shutil.copy2(cur_icon_src, cur_icon_dst)

EOF
