# Cross Hermit — translation project

English translation and modern Windows support for **Cross Hermit: Guardian of the Far Reaches**.

![Cross Hermit English translation patch](docs/assets/social-preview.jpg)

## Contribute

The public test version is ready to play, but we have not tested every mission or hardware configuration. Bug reports, proofreading and playtesting are welcome. Join the retro-trans Discord:

**[discord.gg/MssepShjmB](https://discord.gg/MssepShjmB)**

You can also [open an issue](https://github.com/retro-trans/cross-hermit/issues). Include the installed version, what happened, steps to reproduce it and a screenshot where possible.

## Play it

The latest release is **[v0.8.7](https://github.com/retro-trans/cross-hermit/releases/tag/v0.8.7)**, with an ISO xdelta package for fresh installations and launcher updates for supported existing English installations.

It includes English dialogue and interface text, widescreen and text improvements, updated battle controls, optional support Auto casting, and compatibility and gameplay fixes. **This patch includes gameplay adjustments as well as translation.** A complete live playthrough remains pending.

### Apply

| What you have | What to use |
| --- | --- |
| Original Japanese `EB2002CH.iso` | Retro Trans **Automatic**, or `Cross-Hermit-0.8.7-ISO-patch.zip` |
| Supported English installation, including 0.8.0 | **Check for updates** in `Launcher.exe` |

**Fresh installation**

With [Retro Trans Tools](https://github.com/retro-trans/retro-trans-tools/releases/latest), open **Automatic**, click **Refresh catalog**, browse to your original `EB2002CH.iso`, select **Latest** (0.8.7), and choose a new `.iso` output with **Original format**. Click **Patch**; the app downloads the matching xdelta and verifies both source and output. Mount the resulting ISO and run `SETUP.EXE`.

To use the standalone package instead:

1. Download and extract `Cross-Hermit-0.8.7-ISO-patch.zip` from the release.
2. Run `Patch Cross Hermit.cmd`. Select your original Japanese ISO and choose a new output filename.
3. Mount the patched ISO and run `SETUP.EXE`. Choose a new folder on your hard drive.
4. Open **Cross Hermit English** from its desktop/Start menu shortcut, or run `Launcher.exe` in the installed folder.

**Using Retro Trans Tools:** extract the same ISO patch ZIP, open [Retro Trans](https://github.com/retro-trans/retro-trans-tools/releases/latest), and select **Apply xdelta**. Choose your original `EB2002CH.iso`, the extracted `Cross-Hermit-English-0.8.7.xdelta`, and a new output filename ending in `.iso`. Keep **Output format: Original format**, then apply the patch. Mount the resulting ISO and run `SETUP.EXE` as above. See the [tested steps and expected output hash](docs/RETRO-TRANS.md).

**Other patchers:** use [DeltaPatcher](https://github.com/marco-calautti/DeltaPatcher/releases) or [xdelta3](https://github.com/jmacd/xdelta/releases) with the bare `Cross-Hermit-English-0.8.7.xdelta` release asset, or the identical file inside the ISO patch ZIP. See the [DeltaPatcher instructions and manual xdelta3 command](docs/RETRO-TRANS.md#other-patchers). Keep checksum validation enabled and preserve your untouched original ISO.

You need your own original disc image. The patch expects this exact source; keep checksum verification enabled:

| Source | Expected value |
| --- | --- |
| Filename | `EB2002CH.iso` |
| Size | 659,390,464 bytes |
| SHA-256 | `34a7a1da0e9bb9da44a7397d6873d91d72bced5229ca0cb46d1555f0f95a93f9` |

The patched ISO contains the complete current translation, Windows Forms setup and launcher, native uninstaller and game-local Japanese locale runtime. No separate Locale Emulator installation or system-locale change is needed. Unmount the ISO after installation if you wish; the installed game does not need it.

Requirements: Windows 10/11 on 64-bit Intel/AMD, Windows PowerShell 5.1 and .NET Framework 4.x. Setup needs at least 2.3 GB of free space.

**Existing English installation**

Open `Launcher.exe`, choose **Check for updates**, then install the update with the game closed. Reopen the launcher afterward. From 0.8.7, the launcher asks **Update now?** as soon as it finds a new version: choose **Yes** to begin or **No** to postpone. The older 0.8.0 launcher requires a second click to install this update.

Version 0.8.7 supports English game versions **0.1.261**, **0.1.264** and **0.8.0–0.8.6**. Installations made with installer revisions 0.1.262/0.1.263 report game version 0.1.261 and are supported too. Other installations should use the fresh-install route. The updater does not support unmodified Japanese installations.

The launcher downloads `Cross-Hermit-update.json` and `Cross-Hermit-0.8.7-update.zip`. Use the launcher to apply these assets: it validates the installation and checksums, backs up replaced files and preserves saves and personal settings.

### New in 0.8.7

- Correct ultrawide window sizing, aspect ratio and high-DPI scaling, including 3440×1440 at 225% display scale.
- Remove duplicated tutorial ellipses and fit descriptions to their panels, including location/character articles and deployment help. Shorten the compact attack-type label to **Phys.**
- Replace the captions on 36 tutorial pages and 10 shared resources with reviewed English images, preserving artwork outside the caption regions. Illustrated screenshots can still contain original Japanese text.
- Remove long manual-page fades and shorten fixed navigation waits. Resource loading still takes time. Story/opening/battle-event timing is unchanged.
- Ask **Update now?** when the launcher finds a new version.
- Translate the player-name heading and both normal/highlighted **Confirm** and **Cancel** buttons.

### What is included

- English dialogue, interface text and offline Skills / Classes & upgrades guides in the launcher.
- Widescreen rendering, readable text, corrected interface layouts and two-line item names.
- Ctrl/Shift selection, Ctrl+A, same-class double-click selection and tactical pause.
- Updated skill targeting and optional local support Auto casting, including group support controls.
- Crash, casting-state, stat-calculation, rendering and performance fixes.
- BAD damage over time reduced by 75%, enemy healing reduced by 50% and Wisp HP reduced by 75%.
- Automatic targeting that prefers enemies over destructible walls unless a wall is explicitly targeted.

### Basic battle controls

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

### Saves and uninstall

Saves live in the installation's `SaveData` folder. Close the game before copying them, and keep a separate backup before reinstalling or moving to another computer.

Uninstall from Windows Apps, the Start menu or `Uninstall.exe`. The uninstaller first copies and verifies saves, settings and unrecognized files to **Documents/Cross Hermit Backups**, then removes the owned installation. Restore the backed-up `SaveData` folder into a new installation to continue your progress.

## What is here

| Path | Contents |
| --- | --- |
| `src/` | Current launcher, uninstaller, setup, extraction and disc-support sources |
| `translation/en/` | Selected English-only tutorial and player-name UI exports |
| `docs/assets/` | Social-preview artwork and its generation prompt |
| `docs/RETRO-TRANS.md` | Verified Retro Trans Tools ISO-patching instructions |
| `CHANGELOG.md` | Public release changes and validation summary |

This repository contains release documentation, current tool source and selected English exports. The complete local translation toolchain and script collection are not published here. It contains no game ISO, original Japanese script dump, saves or account credentials. GitHub's automatic source archive is the repository snapshot at the release tag; use the release's ISO patch package or launcher updater to play.

## Do not sell this

This patch is free. Do not sell it or anything made with it: no pre-patched discs or images, no paid installations, and no paywalled or ad-gated downloads.

This is an unofficial fan translation. Original game content and artwork belong to their respective rights holders. The separate licenses for published tool source and bundled components still apply.

## Credits

| Role | Contributor |
| --- | --- |
| Project lead and playtesting | [**pow**](https://github.com/binhlt0402), retro-trans |
| Translation, editing, tooling and reverse engineering assistance | OpenAI Codex, directed by the project lead |

The translation is machine-produced with large language models and then edited, rather than a hand translation by a fluent translator. Names and terminology follow the project's glossary. Review uses accuracy checks, an editorial pass for clarity and character voice, and final proofreading; substantive wording changes are checked again for meaning.

Thanks to the creators of the bundled locale runtime, fonts, graphics compatibility components and patching/extraction tools. Their notices and applicable source archives accompany the distributed components. `src/LICENSE.txt` covers the new project tools only.

The social-preview composition was generated from supplied Cross Hermit artwork using an image-generation tool.

## Status

**v0.8.7 is the current public test release; v0.8.0 was the first public release.** See [CHANGELOG.md](CHANGELOG.md) and the [release notes](https://github.com/retro-trans/cross-hermit/releases/tag/v0.8.7).

Validation covers all 7,985 fresh-install file hashes, compiled setup startup, native uninstall with a verified synthetic save backup, nine supported English update fixtures, 43 updater safety/rollback checks and 34 native application checks. The confirmation flow has 12 offline cases, and the game changes have compiled HUD/native resource and layout checks. Your saves and settings are excluded from distribution.

The ISO patch was decoded back to the complete expected ISO and all original disc files were verified unchanged. Anonymous updater downloads and both Retro Trans **Automatic** and **Apply xdelta** passed against the public assets, including the released Windows app's Automatic route. See [ISO patching verification](docs/RETRO-TRANS.md).

These checks do not establish that every mission, opening sequence or hardware configuration works correctly. A complete live playthrough remains pending. The user's installed game was not changed or started during release testing.

### Human proofreading

There is no audited human proofreading line count for this project yet. Machine review passes are not counted as human proofreading, and a complete human review against the Japanese has not been established. Reports and playtesting have informed corrections; further review is welcome through Discord or GitHub issues.
