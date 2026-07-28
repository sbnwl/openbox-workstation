# COMPONENT-MAP.md

# Openbox Workstation Component Map

This document illustrates the logical architecture of Openbox Workstation
and the relationships between its major components.

---

```text
OPENBOX WORKSTATION
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
└── Appearance
    ├── GTK Themes
    ├── Icons
    ├── Fonts (Inter)
    └── Wallpapers
```

---
```text
UNDER THE HOOD STRUCTURE
~/
├── .config
│   ├── autostart
│   │   ├── blueman.desktop
│   │   ├── guake.desktop
│   │   └── nm-applet.desktop
│   ├── gtk-3.0
│   │   ├── gtk.css
│   │   ├── settings.ini
│   │   └── xfce4-panel-tint2.css
│   ├── openbox
│   │   ├── general_scripts
│   │   │   ├── launchPolkit
│   │   │   └── lockScreen
│   │   ├── menu_scripts
│   │   │   ├── switch2Dock
│   │   │   └── switch2Panel
│   │   ├── scrot_scripts
│   │   │   ├── scrotCrpCopy
│   │   │   ├── scrotCrpSave
│   │   │   ├── scrotScrSave
│   │   │   └── scrotWinSave
│   │   ├── autostart
│   │   ├── menu.xml
│   │   └── rc.xml
│   ├── picom
│   │   └── picom.conf
│   ├── plank
│   │   └── dock1
│   │       └── launchers
│   │           ├── arandr.dockitem
│   │           ├── clock-3.dockitem
│   │           ├── firefox_firefox.dockitem
│   │           ├── geany.dockitem
│   │           ├── jgmenu.dockitem
│   │           ├── libreoffice-calc.dockitem
│   │           ├── libreoffice-impress.dockitem
│   │           ├── libreoffice-writer.dockitem
│   │           ├── lyx.dockitem
│   │           ├── MATLAB.dockitem
│   │           ├── microsoft-edge-1.dockitem
│   │           ├── mpv-1.dockitem
│   │           ├── org.gnome.Calculator.dockitem
│   │           ├── org.gnome.Nautilus.dockitem
│   │           ├── org.gnome.Terminal.dockitem
│   │           ├── org.octave.Octave.dockitem
│   │           └── trash.dockitem
│   ├── tint2
│   │   └── tint2rc
│   └── xfce4
│       ├── panel
│       │   ├── launcher-2
│       │   │   └── 14238899431.desktop
│       │   └── launcher-3
│       │       └── 14238496951.desktop
│       ├── xfconf
│       │   └── xfce-perchannel-xml
│       │       ├── displays.xml
│       │       ├── xfce4-notifyd.xml
│       │       ├── xfce4-panel.xml
│       │       ├── xfce4-settings-editor.xml
│       │       └── xsettings.xml
│       └── helpers.rc
├── .conky-google-now
│   ├── 0.png
│   ├── 1.png
│   :
│   ├── 47.png
│   ├── conky-weather-fetch.sh
│   ├── humidity.png
│   └── wind.png
├── .local
│   └── share
│       ├── applications
│       │   ├── conky.desktop
│       │   ├── lxappearance.desktop
│       │   ├── obconf.desktop
│       │   ├── picom.desktop
│       │   ├── plank.desktop
│       │   ├── tint2conf.desktop
│       │   └── tint2.desktop
│       ├── fonts
│       │   ├── open-sans
│       │   │   ├── OpenSans-LightItalic.ttf
│       │   │   └── OpenSans-Light.ttf
│       │   └── raleway-elementary
│       │       ├── Raleway-Light.ttf
│       │       └── Raleway-Regular.ttf
│       └── themes
│           └── Mistral-Thin
│               └── openbox-3
│                   ├── bullet.xbm
│                   ├── close_hover.xbm
│                   ├── close.xbm
│                   ├── desk_toggled.xbm
│                   ├── desk.xbm
│                   ├── iconify_pressed.xbm
│                   ├── iconify.xbm
│                   ├── max_toggled.xbm
│                   ├── max.xbm
│                   ├── shade_toggled.xbm
│                   ├── shade.xbm
│                   └── themerc
├── .compton.conf
├── .conkyrc
├── .gtkrc-2.0
└── .xsettingsd

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
