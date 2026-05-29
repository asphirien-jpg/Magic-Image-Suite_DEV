# Bewertung der anderen KI-Aussage

Stand: 2026-05-29

Der Nutzer hatte eine andere KI zu dem Acronis-/Cyber-Automationsansatz befragt und wollte nur eine Meinung, ohne Tool-Aenderungen.

## Kurzbewertung

Die Grundrichtung der anderen KI war plausibel:

- Acronis True Image 2021 ist fuer GUI-Restore brauchbar, aber fuer echte Automatisierung ungeeignet.
- Fuer Automatisierung ist ein Produkt mit CLI noetig.
- Acronis Cyber Protect mit `acrocmd` ist der beste bisher getestete Kandidat.
- Zielplattenauswahl ist das Hauptsicherheitsproblem.
- Handoff-Datei zwischen HardwareCheck und Acronis/Postinstall ist sinnvoll.

## Was die andere KI vermutlich nicht im Detail wusste

Die andere KI kannte offenbar nicht alle praktischen Testergebnisse:

- Snap Deploy 6 konnte `.tib` listen, aber das VMD `.tibx` Image nicht korrekt verarbeiten.
- Cyber Protect GUI sieht beide Archive auf `F:`.
- Cyber Protect `acrocmd list disks` funktioniert auf dem Bootmedium.
- BootNext von Debian nach Acronis/Cyber funktioniert bereits.
- HardwareCheck findet inzwischen Images auf separater Images-Partition und schreibt persistenten Handoff.
- Acronis/Cyber Autostart-Hook ueber `ConfigurationFiles/bin/autostart` wurde bereits entdeckt und vorbereitet.

## Eigene Bewertung

Der sinnvollste Weg ist nicht mehr, True Image 2021 GUI weiter zu automatisieren. Der bessere Weg ist:

1. HardwareCheck fuer Auswahl und Sicherheit verwenden.
2. Cyber Protect als CLI-Restore-Engine verwenden.
3. Handoff-Datei als Vertrag zwischen beiden Systemen nutzen.
4. Zielplatte im HardwareCheck eindeutig auswaehlen.
5. Acronis/Cyber Autostart liest Handoff und startet Restore nur bei eindeutiger Lage.

## Wichtigste Korrektur

Nicht zu frueh einen echten automatischen Restore bauen.

Erst braucht es:

- read-only Autostart-Test
- Restore-Plan-Anzeige
- Zielplatten-Validierung
- Sperrregeln fuer USB/Installationsmedien
- doppelten Sicherheitsmechanismus fuer Test-Restore

## Ergebnis

Die andere KI lag in der groben Richtung richtig, aber der aktuelle Projektstand ist weiter. Wir haben bereits eine konkrete Architektur und praktische Tests. Jetzt geht es nicht mehr um Produktwahl, sondern um sichere Umsetzung der Zielplattenauswahl und des Cyber-Autostarts.
