# Naechste Schritte

Stand: 2026-05-29

## Prioritaet 1: Zielplattenauswahl in HardwareCheck

HardwareCheck soll nicht nur Modell und Image auswaehlen, sondern auch die Zielplatte.

Anforderungen:

- Alle Datentraeger anzeigen, aber gesperrte klar markieren.
- Debian-Medium sperren.
- Acronis/Cyber-Medium sperren.
- Images-Partition/Datentraeger sperren.
- USB-Installationsmedien sperren.
- Interne NVMe/SATA als Kandidat anbieten.
- Bei mehreren Kandidaten manuelle Auswahl verlangen.

Zu speichern:

- Linux-Device, z.B. `/dev/nvme0n1`
- Groesse
- Hersteller/Modell
- Seriennummer
- Transport/Bus
- Partitionen/Labels
- Grund, warum erlaubt oder gesperrt

## Prioritaet 2: Handoff erweitern

Die Handoff-Datei muss Zielplatteninformationen enthalten.

Beispiel:

```json
{
  "selected_model": "7770",
  "selected_language": "DE",
  "selected_image_path": "/mnt/Images-sdb2/example.tib",
  "selected_config_path": "/run/live/medium/#configs/7770",
  "precheck_score": 40,
  "source": "HardwareCheck",
  "tool_version": "install-mvp-0.8",
  "restore_automation_requested": true,
  "target_disk": {
    "linux_device": "/dev/nvme0n1",
    "size_bytes": 256060514304,
    "model": "SAMSUNG MZAL4256HBJD-00BL2",
    "serial": "...",
    "transport": "nvme",
    "allow_restore": true
  }
}
```

## Prioritaet 3: Acronis/Cyber Autostart zuerst read-only

Vor echtem Restore muss der Autostart zeigen:

- Handoff gefunden.
- Image gefunden.
- `acrocmd` gefunden.
- Disks gelesen.
- Zielplatte eindeutig erkannt.
- Restore-Plan erstellt.
- Kein Restore ausgefuehrt.

## Prioritaet 4: Acronis/Cyber Restore-Parameter finalisieren

Noch offen:

- exakte `acrocmd recover disk` Syntax fuer `.tib` und `.tibx`
- ob `--arc` oder anderer Parameter noetig ist
- ob Archive-ID/Backup-ID statt Dateiname noetig ist
- Zielplattenangabe per Disknummer oder stabiler ID

Wichtig: Bei CLI-Kommandos im Cyber-Shell ist deutsches Tastaturlayout schwierig. Besser Skripte auf Stick schreiben und ausfuehren, statt lange Kommandos manuell einzutippen.

## Prioritaet 5: End-to-End Test

Nur auf freigegebenem Testgeraet:

1. Debian booten.
2. HardwareCheck starten.
3. Modellnummer eingeben.
4. Image auswaehlen.
5. Zielplatte auswaehlen.
6. Handoff pruefen.
7. BootNext zu Acronis/Cyber.
8. Cyber Autostart read-only pruefen.
9. Restore-Plan anzeigen.
10. Erst danach Test-Restore starten.

## Prioritaet 6: Postinstall

Postinstall soll spaeter nicht erneut nach Config/Modell fragen. Es soll die Handoff-Datei oder eine kopierte Config-Datei lesen.

Moegliche Orte:

- `F:\#handoff\hardwarecheck_install_selection.json`
- kopierte Datei im restored Windows, z.B. `C:\ProgramData\MagicImage\handoff.json`
- Config-Ordner auf Images-Partition

## Erfolgskriterium

Der Ablauf ist erst dann wirklich gut, wenn der Mitarbeiter nur noch diese Schritte macht:

1. Debian/HardwareCheck booten.
2. Modellnummer eingeben.
3. Image waehlen.
4. Zielplatte bestaetigen.
5. Installieren klicken.

Alles danach soll automatisch laufen oder nur noch eindeutige Sicherheitsbestaetigungen zeigen.
