# Source Inventory

Stand: 2026-05-29

## HardwareCheck InstallTool

Aktiver lokaler Quellstand:

- `C:\Users\User\Documents\Codex\2026-05-27\files-mentioned-by-the-user-codex\HardwareCheck_InstallTool_MVP.py`
- Aktive Datei auf Debian-Stick: `E:\HardwareCheck\hardwarecheck_fast_gui.py`
- Version im UI: `install-mvp-0.8`
- SHA256: `2959D18F239815C821835522497E56B0B76A1F815CF6ADBE9937C67BEAB3F337`

Diese Datei ist relativ gross und enthaelt das komplette abgeleitete HardwareCheck-MVP. Neuer Chat soll zuerst die lokale Datei oeffnen und gegen den Hash pruefen.

## Acronis/Cyber Autostart

Im Repo enthalten:

- `src/acronis_cyber_autorestore_autostart.sh`

Lokale Datei:

- `C:\Users\User\Documents\Codex\2026-05-27\files-mentioned-by-the-user-codex\acronis_cyber_autorestore_autostart.sh`

SHA256:

- `30C4A1A43FB38B8CE6E931954DA89A8C10D985A083AC60B87C44596FB6BCED71`

Ziel im Acronis/Cyber Ramdisk:

- `ConfigurationFiles/bin/autostart`

## Cyber Handoff Menu

Lokale Datei:

- `C:\Users\User\Documents\Codex\2026-05-27\files-mentioned-by-the-user-codex\cyber_handoff_menu.sh`

SHA256:

- `9522FA68F595F26D4D7409C77B4B78B218F561D61CBB973D54BF49674A7A7990`

Zweck:

- Diagnose-/Read-only-Menue im Cyber-Bootmedium.
- Handoff anzeigen.
- Disks listen.
- Image read-only pruefen.
- Restore-Plan anzeigen.
- Test-Restore nur mit doppelter Bestaetigung.

## Patch Tools

Im Repo enthalten:

- `tools/patch_cyberprotect_autorestore.py`

Lokale Zusatzdateien:

- `patch_cyberprotect_ramdisk2_autostart.py`
- `build_cyberprotect_winpe_teststick.ps1`
- `build_cyberprotect_iso_teststick.ps1`
- `build_snapdeploy_winpe_teststick.ps1`

Hinweis:

Die Build-Skripte und alten Patch-Skripte sind Entwicklungsartefakte. Fuer die naechste Arbeit ist vor allem der aktive HardwareCheck-Quellstand und der Autostart-Hook relevant.
