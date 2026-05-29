# Dateien und Hashes

Stand: 2026-05-29

Diese Liste dokumentiert die wichtigen lokalen Dateien. Nicht alle Dateien sind im Repo enthalten, weil produktive Images, Acronis-Dateien und Ramdisks nicht hochgeladen werden sollen.

## Arbeitsordner

`C:\Users\User\Documents\Codex\2026-05-27\files-mentioned-by-the-user-codex`

## HardwareCheck

### Lokaler Quellstand

Datei:

`HardwareCheck_InstallTool_MVP.py`

SHA256:

`2959D18F239815C821835522497E56B0B76A1F815CF6ADBE9937C67BEAB3F337`

Groesse laut lokalem Stand: ca. 262 KB

### Aktive Datei auf Debian-Stick

Datei:

`E:\HardwareCheck\hardwarecheck_fast_gui.py`

SHA256:

`2959D18F239815C821835522497E56B0B76A1F815CF6ADBE9937C67BEAB3F337`

Bewertung: identisch mit lokalem MVP-Quellstand.

## Acronis/Cyber Skripte

### Autorestore-Autostart

Datei:

`acronis_cyber_autorestore_autostart.sh`

SHA256:

`30C4A1A43FB38B8CE6E931954DA89A8C10D985A083AC60B87C44596FB6BCED71`

Ziel im Cyber-Ramdisk:

`ConfigurationFiles/bin/autostart`

Status:

Vorbereitet, aber End-to-End-Restore noch nicht final getestet.

### Fallback/Menu

Datei:

`cyber_handoff_menu.sh`

SHA256:

`9522FA68F595F26D4D7409C77B4B78B218F561D61CBB973D54BF49674A7A7990`

Status:

Read-only/Diagnose-Menue fuer Acronis Cyber CLI.

## Patch-Skripte

### Aktiver Autorestore-Patcher

Datei:

`patch_cyberprotect_autorestore.py`

SHA256:

`2F956BE05B265B0DA0986C1C663DA9E6A974649B0D632500C7B5B6D31A125F39`

Status:

Relevant fuer Patch von `ramdisk2.dat` mit Autostart.

### Alter/experimenteller Patcher

Datei:

`patch_cyberprotect_ramdisk2_autostart.py`

Status:

Alter Prototyp/Fallback. Nicht blind verwenden.

## Cyber-Ramdisk auf Stick

### Original

Datei:

`D:\ramdisk2.original.dat`

SHA256:

`485D962753D29FF05C9E8254FA7A550DEBF2EE9BBFAC816D5641E760AAE5486F`

### Aktiv gepatcht

Datei:

`D:\ramdisk2.dat`

SHA256:

`D6EA607B3F2961E027E5681E207CF8CAA17C3C213107FDDD9E31ED821A86B7D9`

### Backup vor letztem Patch

Datei:

`D:\ramdisk2.pre_hc_autorestore.20260529-182525.dat`

## Handoff

Datei:

`F:\#handoff\hardwarecheck_install_selection.json`

Letzter bekannter SHA256:

`6FD058F8104CFEF967F5EAE21D45F6CDEE9A1A0FD3D645B617010CFFAB6F71BE`

Hinweis:

Dieser Handoff war vermutlich noch nicht der finale v0.8-BootNext-Handoff oder wurde vor erneutem Klick erzeugt. Fuer naechsten Test Handoff neu schreiben und Inhalt pruefen.

## Images, nicht hochladen

Auf `F:` lagen:

- `magic_image_v111_operafinal_officetot_25H2_LANFIXX_2part__full_b1_s1_v1.tib`
- `magic_image_VDM_104_a2021patched_operafinal__fresh24H2_officetot__TFT_check_.tibx`

Diese Dateien duerfen nicht in GitHub hochgeladen werden.

## Wiederherstellung Acronis-Stick

Falls Cyber-Stick durch Ramdisk-Patch nicht startet:

```powershell
Copy-Item D:\ramdisk2.original.dat D:\ramdisk2.dat -Force
```
