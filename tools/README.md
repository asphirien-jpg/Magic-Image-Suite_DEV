# Tools Inventory

Stand: 2026-05-29

## Aktives Tool

`patch_cyberprotect_autorestore.py`

Zweck:

- liest eine Acronis/Cyber `ramdisk2.dat`
- entpackt das enthaltene XZ/newc Archiv
- fuegt `ConfigurationFiles/bin/autostart` ein
- schreibt eine neue gepatchte Ramdisk

Abhaengigkeit:

- `patch_cyberprotect_ramdisk2_autostart.py` fuer `Entry`, `parse_newc`, `write_newc`

## Lokale Build-/Patch-Artefakte

Im Arbeitsordner liegen weitere Hilfsskripte:

- `patch_cyberprotect_ramdisk2_autostart.py`
- `build_cyberprotect_winpe_teststick.ps1`
- `build_cyberprotect_iso_teststick.ps1`
- `build_snapdeploy_winpe_teststick.ps1`

Diese wurden im bisherigen Verlauf fuer Teststicks und Ramdisk-Experimente genutzt. Neuer Chat soll sie nur lesen und nicht blind ausfuehren.

## Wichtige Regel

Vor jedem Patch von `D:\ramdisk2.dat` muss ein Backup existieren.

Aktuelles bekanntes Original:

`D:\ramdisk2.original.dat`

Rollback:

```powershell
Copy-Item D:\ramdisk2.original.dat D:\ramdisk2.dat -Force
```

## Keine produktiven Dateien ins Repo

Nicht in GitHub aufnehmen:

- `ramdisk2.dat`
- `ramdisk2.original.dat`
- `.tib`/`.tibx`
- Acronis Installationsdateien
- ISO-Inhalte
- Lizenzdaten
