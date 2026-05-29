# Acronis/Cyber Handoff Test Anleitung

Stand: 2026-05-29

## Ziel

Acronis Cyber Protect soll nach BootNext die von HardwareCheck geschriebene Handoff-Datei finden und das ausgewaehlte Image verarbeiten.

## Test ohne Restore

1. Debian/HardwareCheck booten.
2. Modellnummer eingeben.
3. Image auswaehlen.
4. Handoff speichern.
5. Acronis/Cyber starten.
6. In Cyber nur read-only pruefen:
   - Handoff gefunden?
   - Image gefunden?
   - `acrocmd list disks` funktioniert?
   - `acrocmd list archives --loc=F:\` funktioniert?
   - Zielplatte eindeutig?

## Bekannte Schwierigkeit

Das Keyboardlayout in der BusyBox-Shell ist schwierig. Lange Befehle sollten nicht manuell getippt werden. Besser:

- Skript auf Stick legen.
- Skript mit kurzem Befehl starten.
- Oder Autostart nutzen.

## Wichtige Befehle aus bisherigen Tests

Disks listen:

```sh
/bin/acrocmd list disks
```

Archive auf F listen:

```sh
/bin/acrocmd list archives --loc=F:\
```

Acronis-Dateien auf dem Medium finden, falls Shell offen ist:

```sh
mkdir /m
mount /dev/sdc1 /m
ls /m
```

Falls falsche Partition:

```sh
mount /dev/sdc2 /m
ls /m
```

`go.sh` wurde auf der richtigen Acronis/Cyber-Partition gesehen.

## Restore noch nicht blind starten

Echter Restore darf erst laufen, wenn:

- Zielplatte eindeutig erkannt wurde.
- Zielplatte nicht USB/Images/Debian/Acronis ist.
- Handoff `restore_automation_requested` enthaelt.
- Nutzer Testgeraet freigegeben hat.
- Acronis CLI Syntax fuer das konkrete Image bestaetigt ist.

## Wenn GUI startet statt Autostart

Moegliche Ursachen:

- Autostart-Hook wurde nicht ausgefuehrt.
- Secure-Boot-/Modus-Check blockiert Autostart.
- `ramdisk2.dat` Patch wurde nicht geladen.
- Handoff wurde nicht gefunden und Skript fiel zur GUI zurueck.

Dann naechster Test:

- Shell oeffnen.
- gemountete Partitionen pruefen.
- Log `/tmp/hc_acronis_autorestore.log` suchen.
- `ConfigurationFiles/bin/autostart` im Ramdisk-Patch pruefen.
