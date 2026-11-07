# Changelog

## 0.8.7 — 2026-11-07

Cumulative update from the first public release, 0.8.0.

- Fix ultrawide/aspect-ratio and high-DPI launcher sizing, including 3440×1440 at 225% Windows scale.
- Remove duplicated tutorial ellipses; wrap descriptions inside their actual panels, including location/character articles and deployment help. Shorten the compact Physical label to Phys.
- Install reviewed English captions on all 36 annotated tutorial pages and 10 shared resources (333 caption occurrences), preserving non-caption pixels and illustration-only resources. Original screenshots within the illustrations can retain Japanese text.
- Disable long fades/crossfades and minimize fixed waits in the 26 manual navigation scripts. Preserve input waits, content and unrelated story/opening/battle-event timing.
- Ask Yes/No immediately after the launcher discovers an update. Yes opens the updater; No postpones it. Preserve busy, retry and error handling.
- Translate the player-name dialog heading and both normal/selected Confirm and Cancel captions, preserving the original input/IME behavior.
- Deliver the complete fresh-install ISO delta and cumulative English-install updater. Retain bundled locale support, native launcher/uninstaller and all previous game changes.

Validation: 7,985 installed file hashes; two compiled setup entry-point probes using an extracted disc fixture; native uninstall with synthetic save backup; nine supported English update versions with 533 payload files and six preserved personal files each; 43 safety/rollback cases; 34 native app checks; 12 update-confirmation flow cases; inherited compiled HUD and native description/image checks. ISO reconstruction must match the complete target SHA-256. No game session or full playthrough was run during this release task.

## 0.8.0 — 2026-11-06

First public release, combining the verified translation and game changes through development build 0.1.264.

- Complete fresh-install ISO xdelta package with a standard Windows Forms setup, native launcher/uninstaller and bundled Japanese locale compatibility.
- Installed-game updates through the English launcher, with installation and checksum validation, backups and preservation of saves/settings.
- Widescreen and text/interface improvements, gameplay/control fixes, optional support Auto casting and included balance adjustments.
- Tutorial wording updated for left-click selection, right-click movement/normal attacks, icon/F1-F8 skill targeting, left-click confirmation and right-click cancellation.
- Release version 0.8.0 shown by setup, launcher, uninstaller and game footer.
- Navy/cream Cross Hermit social-preview artwork matching the retro-trans reference style.
- README and release notes follow the SRW-Z project format, with contribution links, installation routes, source scope, credits, machine-translation disclosure and testing limits. This documentation update does not change the release files or tag.
- Verify the published ISO patch ZIP with Retro Trans 0.5.21's Apply xdelta engine: exact output ISO size/SHA-256 and unchanged original. Add manual ISO-patching instructions and output checksums. Patch packages and the release tag remain unchanged.
- Add Retro Trans Automatic discovery: register the Windows PC project, publish the unchanged bare xdelta with its standard manifest/validation and refresh the central catalog. Expand the checksum list to include these assets while preserving the existing package entries. Game/ISO/patch payloads and the release tag remain unchanged.
- Document DeltaPatcher and manual xdelta3 as additional ISO-patching options, including the Windows command, checksum check and original-preservation instructions. Documentation only; release payloads remain unchanged.

Validation includes compiled application tests, inherited compiled/native HUD checks, fresh setup/uninstall and save-preservation fixtures, updater safety/rollback checks, exact ISO reconstruction and release asset checks. This does not constitute a complete live playthrough of every mission or hardware configuration.
