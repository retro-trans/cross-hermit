# Patch the ISO

Cross Hermit English v0.8.7 supports **Automatic** and **Apply xdelta** in [Retro Trans Tools](https://github.com/retro-trans/retro-trans-tools/releases/latest). Existing Retro Trans 0.5.21 clients can refresh the catalog; no application update is needed for this game entry.

## Automatic

1. Open Retro Trans and select **Automatic**.
2. Click **Refresh catalog** to load the Cross Hermit entry.
3. Browse to the original Japanese `EB2002CH.iso`. Its complete size and hash must match the source listed below. The filename may differ.
4. Select **Latest**, which offers the route **original → 0.8.7**.
5. Choose a new output filename ending in `.iso` and keep **Output format: Original format**.
6. Click **Patch**. Retro Trans downloads the matching xdelta and verifies its checksum, the source ISO and the completed English ISO.
7. Mount the output ISO and run `SETUP.EXE`. Start the installed game through its shortcut or `Launcher.exe`.

There is no need to download or extract the ISO patch ZIP for Automatic. The standard release manifest and central catalog identify the exact supported original; a different disc dump will not be treated as compatible. An ISO already patched to 0.8.7 is recognized as current.

## Apply xdelta manually

1. Download and extract `Cross-Hermit-0.8.7-ISO-patch.zip` from the [Cross Hermit release](https://github.com/retro-trans/cross-hermit/releases/tag/v0.8.7).
2. Open Retro Trans and select **Apply xdelta**.
3. Select the original Japanese `EB2002CH.iso` as the source.
4. Select the extracted `Cross-Hermit-English-0.8.7.xdelta` as the patch. Select the `.xdelta` file inside the ZIP, not the ZIP itself.
5. Choose a new output filename, for example `Cross-Hermit-English-0.8.7.iso`. Keep **Output format: Original format**.
6. Apply the patch and compare the reported output SHA-256 with the value below.
7. Mount the resulting ISO and run `SETUP.EXE`. Start the installed game using its shortcut or `Launcher.exe`.

The ISO includes the complete current game patch, modern setup, native launcher/uninstaller and bundled locale support. The installed-game updater remains part of the English launcher.

## Other patchers

Download `Cross-Hermit-English-0.8.7.xdelta` directly from the release, or extract the identical file from `Cross-Hermit-0.8.7-ISO-patch.zip`. These instructions use the same original ISO and produce the same target listed below.

### DeltaPatcher

Open [DeltaPatcher](https://github.com/marco-calautti/DeltaPatcher/releases), select a copy of your original Japanese ISO as **Original file**, and select `Cross-Hermit-English-0.8.7.xdelta` as the patch. Leave **Checksum validation** enabled and apply the patch. Preserve your untouched original separately: DeltaPatcher can replace the selected file when **Backup original file** is disabled.

### xdelta3 command line

Use the `xdelta3.exe` included in the ISO patch ZIP, or obtain [xdelta3](https://github.com/jmacd/xdelta/releases) separately. On Windows, place the executable, original ISO and patch in one folder, open a terminal there, and run:

```powershell
.\xdelta3.exe -d -s "EB2002CH.iso" "Cross-Hermit-English-0.8.7.xdelta" "Cross-Hermit-English-0.8.7.iso"
```

Choose a new output filename and keep checksum verification enabled. Compare the completed ISO's SHA-256 with the table below. Mount it and run `SETUP.EXE` to install the game.

## Expected files

| File | Bytes | SHA-256 |
| --- | --- | --- |
| Original Japanese ISO | 659,390,464 | `34a7a1da0e9bb9da44a7397d6873d91d72bced5229ca0cb46d1555f0f95a93f9` |
| Extracted xdelta | 109,970,381 | `70fe73c9257b27bc0482452fc3f5c14ab523cb088e55f5fa54ceb358a83b463e` |
| Patched English ISO | 770,535,424 | `8a3ecfec28270ebe77fcb586d2c52f358ed8105a41a4782c3aecf71c849ce5ce` |

Retro Trans's manual mode keeps xdelta's checksum checks enabled and reports the output hash. Compare that displayed hash with this table. Automatic checks the complete source and target hashes against the catalog itself.

## Verification

The release xdelta was decoded to a separate ISO and checked against the complete target size and SHA-256 above. The original ISO was rehashed unchanged. All 21 original disc files were also verified byte for byte in the rebuilt ISO.

On 2026-11-07, **Automatic** passed with the public catalog and a clean download cache. It recognized the original ISO, downloaded and verified the published bare xdelta, produced the exact target above and recognized that output as current. The released Windows Retro Trans 0.5.21 app also passed its `--automatic-binary` route using a separate clean patch cache. Both runs were anonymous and preserved the original. See the [Automatic verification record](validation/retro-trans-automatic-0.8.7.json) and the successful [hosted catalog refresh](https://github.com/retro-trans/retro-trans-tools/actions/runs/42336242996). All previous catalog entries were preserved.

The published ISO patch ZIP was separately downloaded and verified, then applied through the **Apply xdelta** `manual_patch` entry point in Retro Trans 0.5.21 (source commit `95f17b987466342edb188eccc54ffb0347c83a68`). The complete output size/hash matched, and the original remained unchanged. See the [manual verification record](validation/retro-trans-manual-0.8.7.json).

The production launcher updater also found 0.8.7 anonymously and downloaded/verified the entire updater payload. See its [verification record](validation/public-update-0.8.7.json).

These are ISO-patching checks, not a game playthrough or a test of compressed CHD/RVZ inputs. The graphical patching interface is not driven by these integration tests.
