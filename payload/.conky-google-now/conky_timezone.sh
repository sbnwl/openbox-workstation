#!/bin/bash
# ~/.conky-google-now/conky_timezone.sh

TZFILE="$HOME/.conky-google-now/timezone"
TZ_VALUE=$(cat "$TZFILE" 2>/dev/null)

case "$1" in
  date) [ -n "$TZ_VALUE" ] && TZ="$TZ_VALUE" date +"%a, %b %d, %Y" || date +"%a, %b %d, %Y" ;;
  hour) [ -n "$TZ_VALUE" ] && TZ="$TZ_VALUE" date +"%H" || date +"%H" ;;
  min)  [ -n "$TZ_VALUE" ] && TZ="$TZ_VALUE" date +"%M" || date +"%M" ;;
esac
