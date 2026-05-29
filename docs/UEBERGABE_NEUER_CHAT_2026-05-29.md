# Uebergabeprotokoll fuer neuen Chat

Stand: 2026-05-29

## Projektname

Magic Image Suite / HardwareCheck InstallTool MVP

## Kurzfassung

Der Nutzer moechte HardwareCheck als Hauptmenue fuer einen Werkstatt-Installationsablauf nutzen. Das Tool soll auf Debian Live laufen, Hardware auslesen, Modellnummer/Config/Image auswaehlen, eine Handoff-Datei schreiben und danach Acronis Cyber Protect booten. Acronis soll dann moeglichst automatisch das ausgewaehlte Image auf die richtige Zielplatte restore'n. Danach soll Windows Postinstall automatisch Treiber installieren und Config/Modell abgleichen.

## Warum dieses Projekt existiert

Der bisherige Ablauf mit Acronis True Image 2021 ist stark GUI-lastig. Mitarbeiter muessen Image und Zielplatte manuell im Acronis Wizard auswaehlen. HardwareCheck macht dann wenig Sinn, wenn danach alles nochmals in Acronis manuell ausgewaehlt werden muss.

Ziel ist daher:

- Auswahl im eigenen HardwareCheck-Menue.
- Nur sichere Zielplatten anbieten.
- Images-Laufwerk, Debian-Stick und Acronis-Stick sperren.
- Danach Acronis/Cyber automatisch oder halbautomatisch starten.
- Langfristig: Acronis/Cyber CLI Restore ohne GUI.

## Produkteinschaetzung

### Acronis True Image 2021

- Bootmedium ist WinPE-artig/GUI-lastig.
- GUI Restore funktioniert.
- Schutz gegen Restore von Quelle auf selben Datentraeger wurde beobachtet.
- Keine brauchbare Bootmedium-CLI fuer vollautomatischen Restore gefunden.
- Fazit: GUI-Fallback ja, echte Automatisierung eher nein.

### Acronis Snap Deploy 6

- WinPE Teststick wurde gebaut.
- CLI `asdcmd` konnte `.tib` Image listen.
- `.tibx` VMD Image schlug fehl: unbekanntes virtuelles Laufwerksformat.
- Da VMD `.tibx` Images gebraucht werden, ist Snap Deploy fuer diesen Ablauf aktuell nicht ausreichend.

### Acronis Cyber Protect

- Linux Bootmedium mit BusyBox und `acrocmd` wurde getestet.
- GUI sieht `.tib` und `.tibx` Archive auf `F:`.
- `acrocmd list disks` funktioniert.
- `acrocmd list archives --loc=F:\` funktioniert.
- Autostart-Hook ueber `ConfigurationFiles/bin/autostart` wurde vorbereitet.
- Fazit: bester Kandidat fuer Automatisierung, aber Restore-Endlauf noch offen.

## Aktuelle Medien und Laufwerke

Beobachtete Windows-Laufwerke am Arbeits-PC:

- `D:` = `CYBER_TEST`, Acronis/Cyber Bootmedium.
- `E:` = `HCDEBIAN`, Debian/HardwareCheck Medium.
- `F:` = `Images`, NTFS Partition mit Images und Handoff.

Im Acronis/Cyber Linux wurden diese Disk-Strukturen gesehen:

- Disk 1: interne Test-NVMe des Laptops, darf fuer Tests ueberschrieben werden.
- Disk 2: `CYBER_TEST (D:)`, FAT32, Acronis/Cyber Medium.
- Disk 3: `HCDEBIAN (E:)` und `Images (F:)` auf einem weiteren Stick/Datentraeger.

## Aktuelle Images

Auf `F:` lagen beim Test:

- `magic_image_v111_operafinal_officetot_25H2_LANFIXX_2part__full_b1_s1_v1.tib`
- `magic_image_VDM_104_a2021patched_operafinal__fresh24H2_officetot__TFT_check_.tibx`

Diese Dateien duerfen nicht ins Repo hochgeladen werden.

## HardwareCheck MVP Stand

Aktive Version im Test: `install-mvp-0.8`

Bisherige Entwicklungsschritte:

- `0.1`: erste Install-vorbereiten Maske.
- `0.2` bis `0.5`: NTFS, Mount, Image-Scan und Handoff verbessert.
- `0.6`: Image-Auswahl eingebaut.
- `0.7`: bessere Acronis-Start-Hinweise.
- `0.8`: `restore_automation_requested` soll erst beim Klick auf BootNext geschrieben werden.

Funktionen:

- 4-stellige Modellnummer eingeben.
- Config-Pfad finden, z.B. `/run/live/medium/#configs/7770`.
- Images auf getrennten Laufwerken finden, besonders auf NTFS Images-Partition.
- Wenn mehrere Images vorhanden sind, Image-Auswahl anzeigen.
- Handoff schreiben, z.B. `/mnt/Images-sdb2/#handoff/hardwarecheck_install_selection.json`.
- BootNext auf Acronis/Cyber setzen und neu starten.

## Handoff-Dateien

Auf der Images-Partition wird ein Uebergabeordner genutzt:

`#handoff`

Wichtige Dateien:

- `hardwarecheck_install_selection.json`
- `recommended_image.txt`
- `selected_config_path.txt`
- `selected_model.txt`

Beispielinhalt der JSON-Idee:

```json
{
  "selected_model": "7770",
  "selected_language": "DE",
  "selected_image_path": "/mnt/Images-sdb2/magic_image_v111_operafinal_officetot_25H2_LANFIXX_2part__full_b1_s1_v1.tib",
  "selected_config_path": "/run/live/medium/#configs/7770",
  "precheck_score": 40,
  "source": "HardwareCheck",
  "restore_automation_requested": true
}
```

Wichtig: In Acronis/Cyber wird derselbe Datentraeger meist als `F:\` gesehen, nicht als Linux-Pfad. Das Autostart-Skript muss die Handoff-Datei auf den Windows-Laufwerken finden und Pfade uebersetzen.

## Acronis/Cyber Autostart Stand

Es wurde ein Skript vorbereitet:

- lokal: `acronis_cyber_autorestore_autostart.sh`
- Ziel im Ramdisk: `ConfigurationFiles/bin/autostart`

Der Hook wurde im Acronis/Cyber Bootmedium entdeckt:

- `/bin/product` kopiert `ConfigurationFiles/bin/autostart` nach `/bin/autostart`.
- Danach wird `/bin/autostart` ausgefuehrt, wenn der Secure-Boot-/Modus-Check passt.

Wichtige lokale Ramdisk-Dateien:

- Aktiv gepatcht: `D:\ramdisk2.dat`
- Original-Backup: `D:\ramdisk2.original.dat`
- Backup vor letztem Patch: `D:\ramdisk2.pre_hc_autorestore.20260529-182525.dat`

Falls das Medium nicht mehr bootet:

```powershell
Copy-Item D:\ramdisk2.original.dat D:\ramdisk2.dat -Force
```

## Was noch nicht final bewiesen ist

- Ob `ConfigurationFiles/bin/autostart` auf jedem Zielgeraet wirklich vor der GUI ausgefuehrt wird.
- Ob `acrocmd recover disk` mit den finalen Parametern fuer `.tib` und `.tibx` sauber laeuft.
- Wie die Zielplatte am robustesten per CLI referenziert wird.
- Ob Acronis Cyber Protect das `.tibx` VMD Image auch per CLI restore'n kann, obwohl die GUI es sieht.

## Wichtige Nutzerentscheidung

Der Nutzer hat ausdruecklich gesagt:

- Die interne NVMe des Test-Laptops darf fuer Tests neu beschrieben werden.
- Es ist ein Testgeraet.

Trotzdem gilt: neuer Chat soll vor echtem Restore nochmal klar bestaetigen lassen, welches Geraet und welche Zielplatte betroffen sind.

## Naechster sinnvoller Schritt

1. HardwareCheck um Zielplattenauswahl erweitern.
2. Zielplatte mit stabilen Merkmalen speichern: Disknummer, Groesse, Modell, Seriennummer, Transport/Bus.
3. Schutzregeln einbauen: keine USB-Sticks, keine Images-Partition, keine Debian-Partition, keine Acronis-Partition.
4. Acronis Autostart erst im Planmodus testen: Handoff lesen, Disks listen, geplanten Restore anzeigen, kein Restore.
5. Danach mit doppelter Bestaetigung Test-Restore starten.
