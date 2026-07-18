# COMPONENT-MAP.md

# Openbox Workstation Component Map

This document illustrates the logical architecture of Openbox Workstation
and the relationships between its major components.

---

```text
Openbox Workstation
│
├── Window Manager
│   └── Openbox
│       ├── rc.xml
│       ├── menu.xml
│       └── autostart
│
├── Desktop Layouts
│   ├── Desktop Layout A
│   │   ├── Tint2
│   │   │   ├── Panel background
│   │   │   ├── Taskbar
│   │   │   └── System tray
│   │   │
│   │   └── XFCE Panel
│   │       ├── Whisker Menu
│   │       ├── Launchers
│   │       └── Panel plugins
│   │
│   └── Desktop Layout B
│       ├── Plank
│       └── jgmenu
│
├── Desktop Services
│   ├── Picom
│   ├── Conky
│   ├── Feh
│   ├── XFCE Notifyd
│   ├── GNOME Screensaver
│   └── PolicyKit GNOME Agent
│
├── System Services
│   ├── Blueman
│   ├── NetworkManager Applet
│   ├── XFCE Power Manager
│   └── Playerctl
│
├── User Utilities
│   ├── Scrot
│   ├── ImageMagick
│   ├── xclip
│   └── xbacklight
│
├── Configuration Tools
│   ├── ObConf
│   ├── lxappearance
│   └── Arandr
│
├── Openbox Scripts
│   ├── Menu Scripts
│   │   ├── switch2Dock
│   │   └── switch2Panel
│   │
│   ├── General Scripts
│   │   ├── launchPolkit
│   │   └── lockScreen
│   │
│   └── Screenshot Scripts
│       ├── scrotScrSave
│       ├── scrotWinSave
│       ├── scrotCrpSave
│       └── scrotCrpCopy
│
├── Appearance
│   ├── GTK Themes
│   ├── Icons
│   ├── Fonts (Inter)
│   └── Wallpapers
│
└── Configuration
    ├── ~/.config/openbox
    │   ├── rc.xml
    │   ├── menu.xml
    │   ├── autostart
    │   ├── menu_scripts/
    │   ├── general_scripts/
    │   └── scrot_scripts/
    │
    ├── ~/.config/tint2
    ├── ~/.config/gtk-3.0
    ├── ~/.config/plank
    ├── ~/.config/xfce4
    ├── ~/.config/picom
    ├── ~/.config/jgmenu
    ├── ~/.conkyrc
    └── ~/.conky-google-now
```

---

## Design Philosophy

Openbox Workstation is organized into modular components, each with a
well-defined responsibility.

Components are selected for functionality, simplicity and long-term
maintainability. Whenever practical, upstream projects are preserved
rather than modified.

This modular architecture allows individual components to be maintained,
replaced or upgraded independently while keeping the workstation stable,
lightweight and easy to understand.
