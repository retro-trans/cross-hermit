# Cross Hermit English

![Cross Hermit English translation patch](docs/assets/social-preview.jpg)

English translation and modern Windows support for **Cross Hermit: Guardian of the Far Reaches**.

**[Download version 0.8.0](https://github.com/retro-trans/cross-hermit/releases/tag/v0.8.0)** · **[Report an issue](https://github.com/retro-trans/cross-hermit/issues)**

## Fresh installation

1. Download and extract `Cross-Hermit-0.8.0-ISO-patch.zip` from the release.
2. Run `Patch Cross Hermit.cmd`. Select your original Japanese `EB2002CH.iso` and choose a new output filename.
3. Mount the patched ISO and run `SETUP.EXE`. Choose a new folder on your hard drive.
4. Open **Cross Hermit English** from the new desktop/Start menu shortcut, or run `Launcher.exe` in the installed folder.

The patched ISO includes the complete translation, gameplay/compatibility fixes, Windows Forms setup and launcher, uninstaller and game-local Japanese locale runtime. No separate Locale Emulator installation or system-locale change is needed. The ISO can be unmounted after installation.

You need your own original game disc image. The full game ISO is not distributed here. The ISO patch expects this exact source:

- Filename: `EB2002CH.iso`
- Size: **659,390,464 bytes**
- SHA-256: `34a7a1da0e9bb9da44a7397d6873d91d72bced5229ca0cb46d1555f0f95a93f9`

Requirements: Windows 10/11, 64-bit Intel/AMD, Windows PowerShell 5.1 and .NET Framework 4.x. Setup needs at least 2.3 GB of free space.

## Update an existing English installation

Open `Launcher.exe`, choose **Check for updates**, then install the available update with the game closed. Reopen the launcher afterward.

Version 0.8.0 supports English game versions **0.1.261** and **0.1.264**, including installations made with installer revisions 0.1.262/0.1.263 that report game version 0.1.261. Other installations should use the fresh-install route. Upgrading an unmodified Japanese installation with the updater is not supported.

The launcher uses `Cross-Hermit-update.json` and `Cross-Hermit-0.8.0-update.zip` from the release. These are updater assets; use the launcher to apply them. It checks the installation and checksums, backs up replaced files and preserves saves and personal settings.

## Included changes

- English dialogue, interface text and offline Skills / Classes & upgrades guides.
- Widescreen rendering, readable text and corrected interface layouts.
- Updated selection, skill targeting, optional local support Auto casting and tactical-pause controls.
- Crash, casting-state, stat-calculation, rendering and performance fixes.
- Balance adjustments: BAD damage over time reduced by 75%, enemy healing reduced by 50% and Wisp HP reduced by 75%.
- Enemy targeting prefers enemies over destructible walls unless a wall is explicitly targeted.
- Bundled Japanese compatibility, disc-independent installed startup, native launcher and save-preserving uninstall.

This patch includes gameplay adjustments as well as translation. See the release notes for validation limits.

## Basic battle controls

| Action | Control |
| --- | --- |
| Select | Left-click or drag |
| Add/remove selection | Ctrl or Shift with selection |
| Select all deployed allies | Ctrl+A |
| Select the same class | Double-click a deployed ally or its portrait |
| Move / normal attack | Right-click ground / an enemy |
| Use a skill | Click its icon or press F1-F8, then left-click a valid target |
| Cancel targeting | Right-click |
| Deploy reserves | Select a reserve portrait, then left-click a deployed ally |
| Tactical pause | Space |

## Saves and uninstall

Saves live in the installation's `SaveData` folder. Close the game before copying them. Keep a separate backup before reinstalling or moving to another computer.

Uninstall from Windows Apps, the Start menu or `Uninstall.exe`. The uninstaller first copies and verifies saves, settings and unrecognized files to **Documents/Cross Hermit Backups**, then removes the owned installation. Restore the backed-up `SaveData` folder into a new installation when you want to continue your progress.

## Project and credits

Published by **retro-trans**. This repository contains release documentation, English-only tutorial exports and the current installer/launcher sources. The ISO patch includes setup source and license notices; the installed files include the matching bundled runtime/font/graphics notices and locale source archives. Original game artwork and game content belong to their respective rights holders. The social-preview composition was generated from supplied project artwork using an image-generation tool.

Version 0.8.0 is the first public test release. Not every mission or hardware configuration has been played through. Report reproducible problems with the game version, steps and a screenshot where possible. Do not include passwords, account credentials or personal files in issue reports.
