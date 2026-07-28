# DESIGN.md

# Openbox Workstation — Design Document

## 1. Purpose

Openbox Workstation is a lightweight desktop environment built around Openbox for users who value:

* reliability
* simplicity
* long-term maintainability
* distraction-free work
* responsiveness on both old and modern hardware

The objective is **not** to create another "riced" desktop.

Instead, the goal is to engineer a workstation that remains enjoyable after thousands of hours of real work.

---

# 2. Foundation

Version 1.0 of this project is preserved exactly as published by the Ubuntu Community Hub author **sbnwl**. 

(https://discourse.ubuntu.com/t/2026-a-beautiful-minimal-and-workable-openbox-based-session-on-new-old-machines/84392)

The original work serves as the historical reference implementation.

Every subsequent version documents only incremental improvements.

The original architecture is respected whenever possible.

---

# 3. Design Principles

## 3.1 Function before Appearance

Visual improvements are welcome only when they do not reduce stability, simplicity or usability.

A beautiful desktop that interferes with productive work is considered a regression.

---

## 3.2 Preserve Working Components

A component is **not** replaced simply because it is newer.

Replacement requires a demonstrable technical advantage.

Examples:

* Picom replaces Compton because it is actively maintained while remaining compatible.
* GNOME Screensaver remains until a demonstrably better lightweight alternative exists.

---

## 3.3 Small Independent Components

Each component should perform one task well.

| Function            | Preferred Component         |
| ------------------- | --------------------------- |
| Window management   | Openbox                     |
| Taskbar             | Tint2                       |
| Desktop menu        | XFCE Whisker Menu or jgmenu |
| Dock                | Plank                       |
| Compositor          | Picom                       |
| Notifications       | XFCE Notifyd                |
| Bluetooth           | Blueman                     |
| Power management    | XFCE Power Manager          |
| Wallpaper           | Feh                         |
| Desktop information | Conky                       |

No single desktop environment should become a mandatory dependency.

---

## 3.4 Native Distribution Packages

Whenever practical, components should come from the distribution repositories (Ubuntu, Fedora, etc.).

Third-party packages are acceptable only when they provide a clear advantage that cannot reasonably be obtained from the distribution.

---

## 3.5 Minimal Dependencies

Every package added increases:

* maintenance
* startup complexity
* update surface
* future compatibility risk

New packages should therefore have a clear justification.

---

## 3.6 Configuration Must Be Understandable

Configuration files should be readable without requiring specialist knowledge.

Shell scripts should be short, documented and logically organized.

The project should remain approachable to someone reading it years later.

---

# 4. Evolution Policy

Version 1.0 remains unchanged.

Development begins with Version 1.1.

Every modification should answer three questions:

1. Why is this change necessary?
2. What measurable benefit does it provide?
3. What new dependency or maintenance cost does it introduce?

If these questions cannot be answered satisfactorily, the original implementation is preferred.

---

# 5. Desktop Philosophy

The desktop should disappear into the background.

The user should think about:

* research
* writing
* programming
* engineering
* learning

—not about the desktop itself.

The interface should be calm, predictable and visually consistent.

---

# 6. Supported Desktop Modes

Two workflows are supported.

## Mode A

Openbox

|

Tint2

|

XFCE Panel

Designed for users who prefer a traditional desktop workflow.

---

## Mode B

Openbox

|

Plank

|

jgmenu

Designed for users who prefer a dock-oriented workflow.

Both modes are first-class configurations and should receive equal maintenance.

---

# 7. Non-Goals

The project deliberately avoids:

* unnecessary visual effects
* excessive animations
* frequent theme changes
* desktop "ricing"
* replacing components without technical justification
* unnecessary desktop-environment dependencies

---

# 8. Long-Term Vision

Openbox Workstation should remain:

* lightweight
* elegant
* stable
* understandable
* modular

The project evolves through small, carefully documented improvements rather than large redesigns.

The objective is to produce a workstation that remains useful for many years while preserving the simplicity that made the original Version 1.0 successful.
