# Anweisung fuer Debian_DEV

Stand: 2026-05-29

Diese Datei beschreibt, was Debian_DEV fuer den HardwareCheck-Installationsablauf bereitstellen muss.

## Ziel

Debian Live soll HardwareCheck als InstallTool starten und folgende Aufgaben unterstuetzen:

- NTFS Images-Partition mounten.
- `#configs` Ordner auf dem Debian-Medium lesen.
- Images auf anderen Laufwerken suchen.
- Handoff persistent auf Images-Partition schreiben.
- BootNext auf Acronis/Cyber setzen.

## Benoetigte Pakete

Im Debian-Live-System sollten vorhanden sein:

- `python3`
- `python3-pygame` oder die vom Tool genutzte GUI-Abhaengigkeit
- `ntfs-3g`
- `efibootmgr`
- `exfatprogs`
- `gdisk`
- `parted`
- `jq`
- `rsync`
- `util-linux`

## HardwareCheck Autostart

Aktive Datei auf dem Debian-Stick:

`E:\HardwareCheck\hardwarecheck_fast_gui.py`

Diese Datei wird vom Debian-Live-System gestartet. Der Nutzer hatte die MVP-Datei entsprechend umbenannt, damit Debian sie automatisch startet.

## Erwartete Ordner

Auf dem Debian-Medium:

- `#configs`
- `HardwareCheck`

Auf der Images-Partition:

- `.tib` / `.tibx` Images
- `#handoff`
- spaeter Postinstall-/Treiber-Skripte

## Mounting

HardwareCheck muss nicht davon ausgehen, dass Images auf derselben Partition wie Debian liegen.

Im Test:

- Debian/HardwareCheck: `E:` / `HCDEBIAN`
- Images: `F:` / `Images`

Im Linux-Live-System wurde Images als z.B. `/mnt/Images-sdb2` gemountet.

## BootNext

`efibootmgr` wird gebraucht, damit HardwareCheck nach Acronis/Cyber booten kann.

Wenn `efibootmgr` fehlt, zeigt HardwareCheck sinngemaess:

`efibootmgr fehlt. Bitte Acronis manuell ueber das Bootmenue starten.`

Wenn BootNext funktioniert, wurde beobachtet:

- BootNext auf `HardwareCheck Acronis` gesetzt.
- Neustart nach Acronis/Cyber gestartet.

## Handoff

HardwareCheck soll die Handoff-Datei immer auf einen beschreibbaren, persistenten Datentraeger schreiben, bevorzugt:

`Images/#handoff/hardwarecheck_install_selection.json`

Nicht geeignet:

- `/run/live/medium/...`, wenn read-only.
- RAM-only Pfade.

## Zukuenftige Erweiterung fuer Debian_DEV

Debian_DEV soll fuer die Zielplattenauswahl moeglichst viele stabile Informationen bereitstellen:

- `/sys/block/*`
- `lsblk -J -O`
- `udevadm info`
- Seriennummern, wenn verfuegbar
- Transport/Bus: nvme, sata, usb
- Partitionen und Labels

Wichtig ist eine klare Sperrliste fuer Installationsmedien.
