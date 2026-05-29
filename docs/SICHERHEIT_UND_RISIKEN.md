# Sicherheit und Risiken

Stand: 2026-05-29

## Groesstes Risiko

Das groesste Risiko ist nicht die Image-Auswahl, sondern die falsche Zielplatte.

Ein automatischer Restore darf nur starten, wenn die Zielplatte eindeutig ist und alle Installations-/Quellmedien ausgeschlossen sind.

## Medien, die nie Zielplatte sein duerfen

Im aktuellen Testaufbau duerfen diese Datentraeger nie als Restore-Ziel gewaehlt werden:

- Acronis/Cyber Bootmedium: `D:` / `CYBER_TEST`
- Debian/HardwareCheck Medium: `E:` / `HCDEBIAN`
- Images Partition: `F:` / `Images`
- jeder Datentraeger, auf dem `#handoff` liegt
- jeder Datentraeger, auf dem `.tib` oder `.tibx` Images liegen
- jeder Datentraeger, der als USB-Stick/USB-Medium erkannt wird, solange er nicht explizit als Testziel freigegeben wurde

## Zielplatte idealerweise

Fuer Produktivbetrieb sollte die Zielplatte normalerweise sein:

- intern
- NVMe oder SATA
- nicht USB
- keine der bekannten Installationspartitionen
- Groesse plausibel
- Modell/Seriennummer sichtbar
- genau eine Kandidatenplatte oder explizite Auswahl im HardwareCheck

## Aktueller Sonderfall

Im Test wurde eine interne NVMe des Test-Laptops ausdruecklich freigegeben. Der Nutzer hat gesagt:

- die interne NVMe darf neu beschrieben werden
- es ist ein Testgeraet

Diese Freigabe gilt nicht automatisch fuer andere Geraete.

## Mindestdaten fuer Zielplattenauswahl

HardwareCheck soll speichern:

- Disknummer im Debian/Linux-Kontext
- Disknummer im Acronis/Cyber-Kontext, wenn bekannt
- Groesse in Bytes/GB
- Hersteller
- Modell
- Seriennummer, falls verfuegbar
- Bus/Transport: NVMe, SATA, USB
- Partitionen/Labels
- Ausschlussgrund, falls gesperrt

## Handoff muss sicherer werden

Die Handoff-Datei sollte spaeter enthalten:

```json
{
  "selected_model": "7770",
  "selected_image_path": "/mnt/Images-sdb2/example.tib",
  "selected_config_path": "/run/live/medium/#configs/7770",
  "target_disk": {
    "linux_device": "/dev/nvme0n1",
    "size_bytes": 256060514304,
    "model": "SAMSUNG MZAL4256HBJD-00BL2",
    "serial": "...",
    "transport": "nvme",
    "allow_restore": true
  },
  "source": "HardwareCheck",
  "restore_automation_requested": true
}
```

## Sicherheitsablauf fuer Acronis Autostart

Empfohlener Ablauf im Acronis/Cyber Autostart:

1. Handoff suchen.
2. Pruefen, ob `restore_automation_requested` true ist.
3. Image-Datei finden.
4. Disks mit `acrocmd list disks` lesen.
5. Zielplatte anhand gespeicherter Merkmale suchen.
6. Wenn nicht eindeutig: abbrechen und Shell/Menu anzeigen.
7. Restore-Plan anzeigen.
8. Nur wenn Testmodus/Bestätigung aktiv ist: Restore starten.
9. Log auf Handoff-/Images-Partition schreiben.

## Harte Abbruchbedingungen

Automatischer Restore muss abbrechen, wenn:

- keine Handoff-Datei gefunden wird
- kein Image gefunden wird
- mehrere Zielplatten passen
- Zielplatte als USB/Installationsmedium erkannt wird
- Zielplatte dasselbe Medium wie Image/`#handoff` ist
- Image-Datei auf Zielplatte liegt
- `acrocmd` fehlt
- `restore_automation_requested` fehlt oder false ist
- kein Zielplatten-Block im Handoff steht

## Wiederherstellung bei defektem Acronis Bootmedium

Falls das gepatchte Cyber-Medium nicht mehr korrekt startet:

```powershell
Copy-Item D:\ramdisk2.original.dat D:\ramdisk2.dat -Force
```

Danach den Stick erneut booten.

## Produktivregel

Solange der erste echte End-to-End-Restore nicht mehrfach auf Testgeraeten funktioniert hat, bleibt Acronis GUI oder ein read-only Acronis-Menue der sichere Fallback.
