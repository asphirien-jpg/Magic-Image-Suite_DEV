# Werdegang

Stand: 2026-05-29

## 1. Anfangsfrage

Der Nutzer wollte wissen, ob HardwareCheck spaeter als Main-Menue dienen kann und ob Acronis automatisch oder halbautomatisch im Hintergrund gestartet werden kann.

Ausgangslage:

- Acronis-Bootmedium separat.
- Images separat.
- Postinstall-/Treiber-Skripte separat.
- HardwareCheck existierte bereits als funktionierende Basis.

## 2. Analyse Acronis True Image 2021

Acronis True Image 2021 wurde als GUI-Bootmedium betrachtet und getestet.

Ergebnis:

- GUI Restore funktioniert.
- Schutz gegen Quelle=Ziel existiert.
- Keine gute Automatisierungs-CLI im Bootmedium gefunden.
- HardwareCheck kann Acronis 21 nur sinnvoll als GUI-Fallback starten, nicht sauber mit vorausgewaehltem Image/Ziel.

## 3. Testidee mit USB-NVMe

Der Nutzer stellte eine schnelle NVMe per USB und ein Testgeraet bereit.

Bewertung:

- Fuer Werkstattablauf ist USB als Installationsmedium normal.
- Als Zielplatte ist USB heikel und muss spaeter gesperrt werden, ausser expliziter Testfall.

## 4. Snap Deploy Versuch

Snap Deploy 6 wurde heruntergeladen und ein WinPE/CLI Teststick gebaut.

Ergebnis:

- `.tib` konnte read-only gelistet werden.
- `.tibx` VMD Image wurde nicht korrekt akzeptiert.
- Snap Deploy ist damit fuer den aktuellen Bedarf nicht ausreichend.

## 5. Wechsel auf Cyber Protect

Acronis Cyber Protect wurde als besserer Kandidat getestet, weil dort `acrocmd` im Bootmedium verfuegbar ist.

Ergebnis:

- Cyber GUI sieht Archive.
- Cyber CLI sieht Disks und Archive.
- Keyboard/Shell im Bootmedium ist fuer manuelle Eingabe unbequem.
- Deshalb muss moeglichst viel per Skript laufen.

## 6. HardwareCheck InstallTool MVP

HardwareCheck wurde als Vorlage genommen, nicht als Ersatz fuer bestehende eigenstaendige Projekte HardwareCheck/ModelFinder.

Gebaut wurde ein InstallTool-MVP:

- Modellnummer-Eingabe.
- Config-Suche.
- Image-Suche auf anderen Laufwerken.
- Image-Auswahl.
- Handoff-Datei.
- BootNext nach Acronis/Cyber.

## 7. Debian_DEV Einbindung

Debian_DEV hat benoetigte Live-System-Bausteine eingebaut:

- NTFS-Support fuer Images.
- `efibootmgr` fuer BootNext.
- weitere Diagnose-/Disk-Tools.

Danach fand HardwareCheck die Images auf `F:`.

## 8. Acronis/Cyber Autostart

Im Cyber-Bootmedium wurde entdeckt:

- `ConfigurationFiles/bin/autostart` kann in `ramdisk2.dat` hinterlegt werden.
- `/bin/product` kopiert und startet diese Datei.

Ein Autostart-Skript wurde vorbereitet, das Handoff lesen und spaeter Restore starten soll.

## 9. Aktueller Punkt

Der Nutzer moechte jetzt nicht weiter im langsamen Chat festhaengen, sondern alles fuer einen neuen Chat dokumentiert und auf GitHub haben.

Aktuelle Richtung:

- HardwareCheck um Zielplattenauswahl erweitern.
- Handoff um Zielplatte erweitern.
- Cyber Autostart im read-only/plan-Modus pruefen.
- Danach echter Test-Restore auf freigegebener interner NVMe.

## 10. Wichtigster Architekturentscheid

Nicht versuchen, Acronis True Image GUI zu fernsteuern.

Stattdessen:

- HardwareCheck macht Auswahl und Sicherheit.
- Acronis Cyber Protect macht Restore per CLI.
- Handoff-Datei ist der Vertrag zwischen beiden Systemen.
