# INSTALL.md

# Openbox Workstation Installation

This document describes the installation procedure for Openbox Workstation Version 1.1.

---

## Supported Distributions

Openbox Workstation is primarily developed on Ubuntu and is expected to work on most modern Linux distributions with appropriate package names.

Current development and testing:

- Ubuntu 24.04 LTS
- Ubuntu 26.04 LTS (target)
- Fedora (use **dnf** instead of **apt**)
- Arch/Manjaro (use **pacman** or **eopkg** instead of **apt**)

---

## 1. Install Required Packages

```bash
sudo apt update

sudo apt install \
openbox xorg \
tint2 xfce4-panel xfce4-whiskermenu-plugin plank jgmenu \
picom feh conky-all xfce4-notifyd gnome-screensaver \
network-manager-gnome blueman xfce4-power-manager playerctl \
fonts-inter lxappearance \
scrot imagemagick xclip arandr \
policykit-1-gnome \
curl unzip
```

---

## 2. Install Openbox Workstation

Copy the configuration files to their respective locations.

Typical directories include:

```text
~/.config/openbox/
~/.config/tint2/
~/.config/gtk-3.0/
~/.config/plank/
~/.config/xfce4/
~/.config/jgmenu/
```

Copy the Conky configuration files into your home directory as required.

---

## 3. Log In

Log out of your current desktop session.

**Right-click → Exit**

From the display manager, select the **Openbox** session and log in.

---

## 4. Select Desktop Mode

Openbox Workstation provides two desktop layouts.

### Mode A

- Tint2
- XFCE Panel

### Mode B

- Plank
- jgmenu

Switch between them from the desktop menu:

**Right-click → Next Login**

The selected desktop mode will become active after your next login.

---

## 5. Reconfigure Openbox

After modifying Openbox configuration files, right-click on the desktop and select:

**Reconfigure**

The changes will be applied immediately without logging out.

---

## Notes

- Picom is the default compositor.
- Compton is retained only as a compatibility fallback.
- GNOME Screensaver and xbacklight are transitional components and may be replaced in future releases.
- Openbox Workstation follows an incremental development philosophy, preserving upstream work whenever practical.
