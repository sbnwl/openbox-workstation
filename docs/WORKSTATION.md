# WORKSTATION.md

# Openbox Workstation

## Version 1.1

---

## Overview

This document describes the composition of Openbox Workstation Version 1.1.

It serves as the technical reference for the workstation at this release.

---

## Philosophy

Openbox Workstation combines mature lightweight Linux desktop
components into a cohesive workstation while preserving their independence. Components are selected based on functionality,
stability and maintainability rather than strict desktop
environment boundaries.

# Desktop Layouts

Openbox Workstation officially supports two desktop layouts.

## Desktop Layout A — Traditional Desktop

* Openbox
* Tint2 (Panel Background + Taskbar + System Tray)
* XFCE Panel (Whisker Menu + Launchers + Panel Plugins)

## Desktop Layout B — Dock-Oriented Desktop

* Openbox
* Plank Dock
* jgmenu

---

# Core Workstation Components

The following table summarizes the core capabilities of Openbox Workstation and their current implementation.

| Capability                       | Current Implementation | Status                  |
| -------------------------------- | ---------------------- | ----------------------- |
| Window Management                | Openbox                | Core                    |
| Desktop Compositing              | Picom                  | Core                    |
| Wallpaper Management             | Feh                    | Core                    |
| Desktop Board                    | Conky                  | Core                    |
| Taskbar + Notification Area      | Tint2                  | Core (Desktop Layout A)           |
| Application Menu + Panel Plugins | XFCE Panel             | Core (Desktop Layout A)           |
| Dock                             | Plank                  | Core (Desktop Layout B)           |
| Application Menu                 | jgmenu                 | Core (Desktop Layout B)           |
| Desktop Notifications            | XFCE Notifyd           | Core                    |
| Bluetooth Management             | Blueman                | Core                    |
| Network Management               | NetworkManager Applet  | Core                    |
| Power Management                 | XFCE Power Manager     | Core                    |
| Screen Locking                   | GNOME Screensaver      | Core · Transitional     |
| Multimedia Controls              | Playerctl              | Core                    |
| Screenshot Capture               | Scrot                  | Core                    |
| Screenshot Processing            | ImageMagick            | Core                    |
| Clipboard Integration            | xclip                  | Core                    |
| Brightness Control               | xbacklight             | Core · Transitional     |
| Desktop Font Family              | Inter                  | Core                    |
| Openbox Configuration Utility    | ObConf                 | Transitional            |
| Menu Editor                      | ObMenu                 | Transitional            |
| Compatibility Compositor         | Compton                | Transitional (Fallback) |
| Graphical Authentication | PolicyKit GNOME Agent | Core |

---

# Installation Dependencies

The following packages are required to install, configure or maintain Openbox Workstation but are not necessarily persistent desktop components.

| Package      | Purpose                                            |
| ------------ | -------------------------------------------------- |
| xorg         | X11 display server                                 |
| wget         | Download installation resources                    |
| curl         | Download utilities and online resources            |
| unzip        | Extract installation archives                      |
| lxappearance | Configure GTK themes, icons and fonts              |
| arandr       | Configure display layouts and multi-monitor setups |

---

# Current Design Principles

* Functionality before aesthetics.
* Lightweight, modular desktop components.
* Preserve upstream work whenever practical.
* Minimize unnecessary dependencies.
* Improve incrementally.
* Document significant architectural decisions.

---

# Version Highlights

Version 1.1 introduces:

* Picom as the default compositor.
* Blueman integration.
* XFCE Power Manager.
* Universal multimedia controls using Playerctl.
* Inter font family.
* Improved configuration consistency.
* Support for panel and dock-oriented desktop layouts.
* Comprehensive project documentation.
* General cleanup while preserving compatibility with the original Version 1.0.
