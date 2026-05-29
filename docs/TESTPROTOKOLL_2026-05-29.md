# Testprotokoll 2026-05-29

Dieses Protokoll fasst die bisherigen Tests aus dem Chat zusammen.

## Ausgangspunkt

Der Nutzer hatte:

- Acronis 21 / True Image 2021 Bootmedium
- separate Images-Partition mit `.tib` und `.tibx`
- HardwareCheck auf Debian Live
- Testgeraet mit interner NVMe, die fuer Tests ueberschrieben werden darf

## Acronis True Image 2021

Beobachtungen:

- GUI startet im Bootmedium.
- Recovery Wizard kann Images anzeigen.
- Zielplattenauswahl zeigt Disknummer, Kapazitaet, Modell und Interface.
- Schutz gegen Quelle = Ziel wurde beobachtet: Acronis meldete, dass ein Backup nicht auf denselben Datentraeger restored werden kann, auf dem das Backup liegt.
- Bei Restore auf nicht-leere Zielplatte kommt Warnung, dass Partitionen geloescht werden.

Bewertung:

- Als manueller Fallback brauchbar.
- Fuer vollautomatischen Ablauf aus HardwareCheck heraus nicht ideal.
- Keine sinnvolle CLI im True-Image-2021-Bootmedium gefunden.

## Snap Deploy 6

Teststick wurde gebaut.

Read-only Tests:

- Images wurden gefunden.
- `asdcmd /list` konnte das `.tib` Image listen.
- `.tibx` VMD Image schlug fehl mit sinngemaess: unbekanntes Format des virtuellen Laufwerks.

Bewertung:

- Fuer reine `.tib` evtl. brauchbar.
- Fuer den aktuellen Ablauf nicht ausreichend, weil VMD `.tibx` Images gebraucht werden.

## Acronis Cyber Protect

Cyber Bootmedium wurde getestet.

Beobachtungen:

- GUI `Bootable Backup Agent` startet.
- Mit `Alt+F2`/Shell konnte BusyBox erreicht werden.
- `/bin/acrocmd list disks` funktionierte.
- GUI sieht zwei Archive auf `F:`.
- `acrocmd list archives --loc=F:\` zeigte beide Archive.
- Sonderzeichen/Keyboardlayout im BusyBox-Terminal waren fuer den Nutzer schwierig.

Wichtiger Disk-Stand in Acronis:

- Disk 1: interne NVMe / Windows11 Testplatte
- Disk 2: `CYBER_TEST (D:)`
- Disk 3: `HCDEBIAN (E:)` und `Images (F:)`

## HardwareCheck MVP Tests

### Versionen

- v0.1: Install-vorbereiten Button eingebaut.
- v0.2/v0.3: Handoff-Pfad/Mounting verbessert.
- v0.5: Images auf `F:` wurden gefunden.
- v0.6: Image-Auswahl unten im Dialog.
- v0.7: Acronis Start-Dialog mit klarerem Hinweis.
- v0.8: Auto-Restore-Wunsch erst beim BootNext-Klick.

### Ergebnisse

- Debian startet HardwareCheck.
- Modellnummer-Eingabe funktioniert.
- Config-Pfad wird gefunden, z.B. `/run/live/medium/#configs/7770`.
- NTFS Images-Partition konnte mit `ntfs-3g` gemountet werden.
- Images wurden gefunden.
- Image-Auswahl funktioniert.
- Handoff wird persistent auf Images-Partition geschrieben.
- BootNext nach Acronis/Cyber funktionierte.

## Debian_DEV Aenderungen

Debian_DEV Chat hat laut Nutzer die benoetigten Pakete/Anpassungen eingebaut. Besonders relevant:

- `ntfs-3g`
- `efibootmgr`
- `exfatprogs`
- `gdisk`
- `jq`
- `parted`
- `rsync`

Damit wurden NTFS-Mount und BootNext robuster.

## Acronis/Cyber Autostart Patch

Getestete Erkenntnis:

- Auf dem Cyber-Stick existiert `ramdisk2.dat`.
- In `/bin/product` wurde ein Autostart-Mechanismus entdeckt.
- `ConfigurationFiles/bin/autostart` wird nach `/bin/autostart` kopiert und ausgefuehrt.
- Ein Autostart-Skript wurde in `ramdisk2.dat` eingebaut.

Noch nicht final bewiesen:

- Ob der Autostart bei jedem Boot vor der GUI wirklich laeuft.
- Ob der Restore-Plan automatisch erstellt wird.
- Ob `acrocmd recover disk` mit den finalen Parametern sauber funktioniert.

## Letzter beobachteter Zustand

Nach BootNext landete das Geraet wieder im Cyber Bootmedium/GUI. Der Nutzer kam zeitweise in Shell/Menu, musste aber neu starten und kam dann nicht mehr einfach dorthin. Deshalb wurde entschieden:

- Wir gehen konzeptionell davon aus, dass der Cyber-CLI-Weg funktioniert.
- Das Tool soll weiter Richtung Vollautomatik gebaut werden.
- Zielplattenauswahl und Autorestore-Handoff sind die naechsten Schritte.

## Offene Tests

1. Handoff nach v0.8 neu erzeugen und pruefen, ob `restore_automation_requested` enthalten ist.
2. Cyber Autostart testen, ob er vor GUI startet.
3. Cyber Autostart read-only laufen lassen: Handoff lesen, Image finden, Disks listen, Restore-Plan anzeigen.
4. Danach erst echter Restore auf die freigegebene interne Test-NVMe.
