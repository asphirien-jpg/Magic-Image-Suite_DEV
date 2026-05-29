# Architektur

Stand: 2026-05-29

## Zielarchitektur

```text
Debian Live
  -> HardwareCheck InstallTool
    -> Modellnummer / Config / Image / Zielplatte auswaehlen
    -> Handoff auf Images-Partition schreiben
    -> BootNext auf Acronis/Cyber setzen
      -> Acronis Cyber Protect Linux Bootmedium
        -> Autostart-Skript liest Handoff
        -> acrocmd prueft Disks und Image
        -> Restore auf Zielplatte
          -> Windows bootet
            -> Postinstall liest Handoff/Config
            -> Treiberinstallation
            -> Finaler Config-/Addins-Check
```

## Komponenten

### 1. Debian/HardwareCheck

Aufgabe:

- Hardware auslesen.
- Modellnummer annehmen.
- Config suchen.
- Images auf externen/anderen Partitionen suchen.
- Image-Auswahl anzeigen.
- Handoff-Datei schreiben.
- Acronis/Cyber per BootNext starten.

Aktive Datei auf dem Stick:

`E:\HardwareCheck\hardwarecheck_fast_gui.py`

Lokaler Quellstand:

`HardwareCheck_InstallTool_MVP.py`

### 2. Images-Partition

Aufgabe:

- `.tib` und `.tibx` Images bereitstellen.
- Handoff-Dateien speichern.
- Spaeter Postinstall-Skripte/Config bereitstellen.

Aktueller Pfad im Test:

`F:\`

Linux-Mount im Debian-Test:

`/mnt/Images-sdb2`

Handoff:

`F:\#handoff\hardwarecheck_install_selection.json`

### 3. Acronis/Cyber Bootmedium

Aufgabe:

- CLI/GUI fuer Restore bereitstellen.
- Spaeter Handoff automatisch lesen.
- Image auf Zielplatte restore'n.

Aktueller Pfad im Test:

`D:\`

Wichtige Datei:

`D:\ramdisk2.dat`

Autostart-Hook:

`ConfigurationFiles/bin/autostart`

### 4. Windows Postinstall

Aufgabe:

- Nach Windows-Installation Treiber installieren.
- Modell/Config pruefen.
- Addins/Config final vergleichen.

Noch nur grob betrachtet. Der spaetere Postinstall sollte die Modellnummer/Config nicht erneut vom Mitarbeiter verlangen, sondern aus der Handoff-Datei oder einer kopierten Config lesen.

## Handoff-Ort

Bester Ort aktuell:

`Images-Partition/#handoff`

Begruendung:

- Debian kann dort schreiben.
- Acronis/Cyber kann diese Partition als `F:` sehen.
- Windows/Postinstall kann spaeter ebenfalls darauf zugreifen.
- Der Ordner liegt nicht in der Debian-Live-Root, die read-only sein kann.

## Handoff-Inhalt

Minimal heute:

- Modellnummer
- Config-Pfad
- Image-Pfad
- Sprache
- Precheck-Wert
- Quelle: HardwareCheck

Zukuenftig zwingend:

- Zielplattenauswahl mit stabilen Merkmalen
- Restore-Freigabe
- Sicherheitsstatus
- Zeitstempel
- Tool-Version

## Pfadproblem Linux vs Acronis

HardwareCheck schreibt Linux-Pfade wie:

`/mnt/Images-sdb2/example.tib`

Acronis/Cyber sieht dieselbe Partition als:

`F:\example.tib`

Das Autostart-Skript muss daher:

1. Handoff-Datei auf bekannten Laufwerksbuchstaben suchen.
2. Den Dateinamen aus dem Linux-Pfad extrahieren.
3. Das Image auf dem Acronis-Laufwerk suchen.
4. Den Acronis-kompatiblen Pfad fuer `acrocmd` verwenden.

## Empfohlener Acronis-Autostart-Modus

Erste produktionsnahe Version sollte drei Modi haben:

- `readonly`: nur Handoff/Disks/Image pruefen, keinen Restore.
- `plan`: Restore-Plan anzeigen, keinen Restore.
- `restore`: Restore nur mit eindeutiger Zielplatte und Freigabe.

Default muss `readonly` oder `plan` sein, bis die End-to-End-Tests bestanden sind.
