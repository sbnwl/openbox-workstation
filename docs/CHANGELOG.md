# CHANGELOG.md

# Openbox Workstation Changelog

## Version 1.1
Openbox Workstation v1.1 is the first project release built upon the original Ubuntu Community Hub Openbox package. This release focuses on improving usability, maintainability, documentation and long-term project sustainability while preserving the original lightweight philosophy.

### Added

* Added Picom as the default compositor.
* Added Blueman integration for Bluetooth management.
* Added NetworkManager Applet integration.
* Added XFCE Power Manager for power management.
* Added Playerctl for universal multimedia key support.
* Added Inter font family for desktop elements.
* Added `XF86Search` keybinding to open ChatGPT.
* Added new lockScreen script for smooth locking using any locker.
* Added configuration backup utility
(backup_openbox_workstation_config.sh).
* Added configuration install utility
(install_openbox_workstation_config.sh).
* Added project documentation:

  * `README.md`
  * `INSTALL.md`
  * `WELCOME.md`
  * `WORKSTATION.md`
  * `COMPONENT-MAP.md`
  * `DESIGN.md`
  * `CHANGELOG.md`

---

### Transitional Components

The following components remain supported while suitable long-term
replacements are evaluated.

| Component |	Status
| xbacklight	| Transitional
| GNOME Screensaver	| Transitional
| Compton	Compatibility | fallback
| ObConf |	Transitional
| ObMenu	| Awaiting a maintained Python 3 successor

### Changed

* Preserved Compton as a fallback compositor but no longer use it by default.
* Updated multimedia keybindings from Clementine-specific commands to Playerctl.
* Improved `autostart` header with project name, version and purpose.
* Introduced a GTK CSS overlay that renders the XFCE Panel transparent, allowing Tint2 to provide the visible panel background while preserving Whisker Menu, launchers and panel plugins.
* Added XDG desktop-data path initialization to improve XFCE Panel plugin discovery in minimal Openbox sessions and newer XFCE releases.
* Improved `switch2Dock` and `switch2Panel` scripts with safer directory handling and quoted variables.
* Clarified desktop modes:
  * Desktop layout A: Tint2 + XFCE Panel
  * Desktop layout B: Plank + jgmenu
* Improved project organization and repository structure. 
* Audited and cleaned Openbox configuration files.
* Reorganized Openbox helper scripts.

---

### Desktop
- Introduced two interchangeable desktop layouts:
  - Desktop Layout A – Traditional panel
  - Desktop Layout B – Dock and launcher
- Added menu-driven desktop layout switching for the next login.
- Improved startup sequence through a reorganized Openbox autostart
configuration.
- Standardized desktop startup timing and component initialization.

---

### User Experience
- Added universal multimedia key support using Playerctl.
- Added Search key integration for launching ChatGPT in the default
web browser.
- Improved keyboard shortcuts and window management behavior.
- Improved screenshot utilities and clipboard integration.
- Added a comprehensive post-installation welcome guide
(WELCOME.txt).

---

### Desktop Components
- Picom adopted as the default compositor.
- Added Blueman integration.
- Added XFCE Power Manager.
- Adopted the Inter font family.
- Continued support for GNOME Screensaver as the default screen locker.
- Added PolicyKit GNOME authentication agent for graphical privilege prompts.

---

### Preserved

* Preserved GNOME Screensaver as the current screen-locking implementation.
* Preserved xbacklight as the current brightness-control implementation.
* Preserved the ImageMagick-based screenshot clipboard workflow.
* Preserved the original Conky desktop board and weather widget.
* Preserved the original menu structure with minimal changes.
* Preserved Version 1.0 as the historical reference implementation.

---

### Deferred

* Replacement of GNOME Screensaver.
* Replacement of xbacklight with a secure brightness-control mechanism.
* Adoption of Ulauncher.
* Further Whisker Menu theming.
* Further visual refinement of Tint2 and Conky.

# Version 1.0

The original Openbox desktop package published through the Ubuntu
Community Hub by user sbnwl serves as the reference implementation upon which Openbox Workstation is based.