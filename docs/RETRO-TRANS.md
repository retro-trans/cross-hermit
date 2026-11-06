# Patch the ISO with Retro Trans Tools

Cross Hermit English v0.8.0 supports **Automatic** and **Apply xdelta** in [Retro Trans Tools](https://github.com/retro-trans/retro-trans-tools/releases/latest). Existing Retro Trans 0.5.21 clients can refresh the catalog; no application update is needed for this game entry.

## Automatic

1. Open Retro Trans and select **Automatic**.
2. Click **Refresh catalog** to load the Cross Hermit entry.
3. Browse to the original Japanese `EB2002CH.iso`. Its complete size and hash must match the source listed below. The filename may differ.
4. Select **Latest**, which offers the route **original → 0.8.0**.
5. Choose a new output filename ending in `.iso` and keep **Output format: Original format**.
6. Click **Patch**. Retro Trans downloads the matching xdelta and verifies its checksum, the source ISO and the completed English ISO.
7. Mount the output ISO and run `SETUP.EXE`. Start the installed game through its shortcut or `Launcher.exe`.

There is no need to download or extract the ISO patch ZIP for Automatic. The standard release manifest and central catalog identify the exact supported original; a different disc dump will not be treated as compatible. An ISO already patched to 0.8.0 is recognized as current.

## Apply xdelta manually

1. Download and extract `Cross-Hermit-0.8.0-ISO-patch.zip` from the [Cross Hermit release](https://github.com/retro-trans/cross-hermit/releases/tag/v0.8.0).
2. Open Retro Trans and select **Apply xdelta**.
3. Select the original Japanese `EB2002CH.iso` as the source.
4. Select the extracted `Cross-Hermit-English-0.8.0.xdelta` as the patch. Select the `.xdelta` file inside the ZIP, not the ZIP itself.
5. Choose a new output filename, for example `Cross-Hermit-English-0.8.0.iso`. Keep **Output format: Original format**.
6. Apply the patch and compare the reported output SHA-256 with the value below.
7. Mount the resulting ISO and run `SETUP.EXE`. Start the installed game using its shortcut or `Launcher.exe`.

The ISO includes the complete current game patch, modern setup, native launcher/uninstaller and bundled locale support. The installed-game updater remains part of the English launcher.

## Expected files

| File | Bytes | SHA-256 |
| --- | --- | --- |
| Original Japanese ISO | 659,390,464 | `34a7a1da0e9bb9da44a7397d6873d91d72bced5229ca0cb46d1555f0f95a93f9` |
| Extracted xdelta | 109,768,153 | `7fb38188c1f17a4ffdeea783083c9764b0c9128bc1c77bb1c125c987301e6c80` |
| Patched English ISO | 770,318,336 | `87ad84b9a0fb92657f19d5db2a91e361d8e7f7a2b57a6e31852fa7e3a25d54e2` |

Retro Trans's manual mode keeps xdelta's checksum checks enabled and reports the output hash. Compare that displayed hash with this table. Automatic checks the complete source and target hashes against the catalog itself.

## Verification

Automatic was verified against the published central catalog with an empty patch cache: the original was identified, the published bare xdelta downloaded and verified, and the English ISO checked against its complete size and SHA-256. The completed ISO was then recognized as already current. The released Windows `Retro-Trans.exe` v0.5.21 also passed its `--automatic-binary` route using the public catalog and another empty patch cache. Both runs preserved the original and required no credentials.

The [hosted catalog refresh](https://github.com/retro-trans/retro-trans-tools/actions/runs/42190093593) and [Retro Trans checks](https://github.com/retro-trans/retro-trans-tools/actions/runs/42189826153) passed. [Verification records](validation/retro-trans-automatic.json) contain the output identity and packaged-app result.

On 2026-11-06, the published ISO patch ZIP was downloaded without credentials and verified against its published SHA-256. Its xdelta was passed to the same `manual_patch` entry point used by Retro Trans's interface, using Retro Trans 0.5.21 source commit `c0fea9b3c9d000d3441f1912c1b7d7e33ab9d42a` and its verified xdelta3 3.2.0 engine.

The entire output matched the expected size and SHA-256 above. The original ISO was rehashed afterward and was unchanged. This verifies ISO patching; it is not an additional game playthrough or a test of compressed CHD/RVZ inputs. The graphical interface was not driven during this integration check.
