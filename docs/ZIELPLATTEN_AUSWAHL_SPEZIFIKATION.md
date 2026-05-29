# Zielplatten-Auswahl Spezifikation

Stand: 2026-05-29

## Ziel

HardwareCheck soll die Zielplatte vor dem Boot nach Acronis/Cyber auswaehlen. Acronis soll spaeter nicht blind selbst eine Platte raten.

## Warum

Das falsche Ueberschreiben eines Datentraegers ist das groesste Risiko im gesamten Projekt.

## UI-Idee in HardwareCheck

Nach Modellnummer und Image-Auswahl:

1. Dialog `Zielplatte waehlen` anzeigen.
2. Alle Datentraeger listen.
3. Gesperrte Datentraeger sichtbar, aber nicht auswaehlbar machen.
4. Nur sichere Kandidaten auswaehlbar machen.
5. Wenn genau ein Kandidat vorhanden ist, trotzdem anzeigen und bestaetigen lassen.
6. Vor `Acronis starten` eine Zusammenfassung zeigen.

## Sperrregeln

Sperren, wenn:

- Datentraeger enthaelt Debian/HardwareCheck.
- Datentraeger enthaelt Acronis/Cyber.
- Datentraeger enthaelt Images oder `#handoff`.
- Datentraeger ist USB und nicht explizit als Testziel freigegeben.
- Datentraeger enthaelt `.tib` oder `.tibx` Images.
- Datentraeger hat Label `CYBER_TEST`, `HCDEBIAN`, `Images`, `ACRONIS_MEDIA` oder aehnlich.

## Kandidatenregel

Erlauben, wenn:

- intern
- NVMe oder SATA
- nicht Quell-/Installationsmedium
- Groesse plausibel
- Modell/Seriennummer auslesbar oder mindestens eindeutig

## Zu speichernde Felder

```json
"target_disk": {
  "linux_device": "/dev/nvme0n1",
  "linux_pkname": "nvme0n1",
  "size_bytes": 256060514304,
  "size_gb": 256,
  "model": "SAMSUNG MZAL4256HBJD-00BL2",
  "serial": "...",
  "vendor": "SAMSUNG",
  "transport": "nvme",
  "bus": "nvme",
  "is_usb": false,
  "is_install_media": false,
  "is_image_media": false,
  "allow_restore": true,
  "selection_source": "HardwareCheck"
}
```

## Acronis-Seite

Acronis/Cyber sieht andere Disknummern als Debian. Darum soll das Autostart-Skript nicht nur Disknummern vergleichen, sondern:

- Groesse
- Modell
- Seriennummer, falls sichtbar
- Partitionen/Labels
- Ausschlussregeln

Wenn Acronis die Zielplatte nicht eindeutig zuordnen kann: abbrechen.

## Testgeraet Sonderfall

Im aktuellen Test darf die interne NVMe ueberschrieben werden. Dieser Sonderfall sollte im Handoff sichtbar sein, z.B.:

```json
"test_device_restore_allowed": true
```

Diese Freigabe darf nicht automatisch fuer andere Geraete gelten.

## Minimum fuer MVP

Wenn Zielplattenauswahl im ersten Schritt einfach bleiben soll:

- Liste mit Disk-Groesse/Modell/Bus anzeigen.
- USB/Images/Debian/Acronis sperren.
- einen internen Kandidaten auswaehlen lassen.
- Auswahl in Handoff schreiben.
- Acronis Autostart prueft spaeter nochmals.
