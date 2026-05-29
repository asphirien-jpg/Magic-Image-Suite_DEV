# Quickstart fuer neuen Chat

Stand: 2026-05-29

## Zielbild

Der Nutzer baut ein Installationswerkzeug fuer Werkstatt-/Serieninstallation:

1. Debian Live bootet.
2. HardwareCheck startet automatisch.
3. Mitarbeiter gibt eine 4-stellige Modellnummer ein.
4. HardwareCheck prueft Configs und vorhandene Magic Images.
5. Mitarbeiter waehlt Image und spaeter Zielplatte.
6. HardwareCheck schreibt eine Handoff-Datei auf die Images-Partition.
7. HardwareCheck setzt BootNext auf Acronis/Cyber und startet neu.
8. Acronis Cyber Protect liest Handoff und restored automatisch auf die ausgewaehlte Zielplatte.
9. Windows bootet, Postinstall installiert Treiber und prueft Config/Modell.

## Sofort lesen

- `UEBERGABE_NEUER_CHAT_2026-05-29.md`
- `SICHERHEIT_UND_RISIKEN.md`
- `TESTPROTOKOLL_2026-05-29.md`
- `DATEIEN_UND_HASHES.md`

## Aktive lokale Dateien auf dem Arbeitsrechner

Wichtig: Die grossen/aktiven lokalen Dateien wurden nicht alle ins Repo geschrieben, weil keine produktiven Images, keine Acronis-Dateien und keine Ramdisks ins Repo sollen. Die aktiven Pfade sind dokumentiert.

- Arbeitsordner: `C:\Users\User\Documents\Codex\2026-05-27\files-mentioned-by-the-user-codex`
- Aktive HardwareCheck-Datei auf Debian: `E:\HardwareCheck\hardwarecheck_fast_gui.py`
- Lokaler Quellstand: `HardwareCheck_InstallTool_MVP.py`
- Acronis/Cyber Bootstick: `D:` / Label `CYBER_TEST`
- Debian/HardwareCheck Partition: `E:` / Label `HCDEBIAN`
- Images Partition: `F:` / Label `Images`

## Nicht blind tun

- Kein Restore ohne ausdruecklich freigegebenes Testgeraet.
- Keine `.tib`/`.tibx` Images hochladen.
- Keine Acronis-Ramdisks oder Installationsdateien hochladen.
- Keine produktiven Datentraeger ueberschreiben.
- Bei Acronis/Cyber erst read-only Tests und Plan anzeigen lassen.

## Naechste technische Aufgabe

Die naechste sinnvolle Aufgabe ist nicht mehr Image-Suche oder BootNext. Das funktioniert grundsaetzlich.

Die naechste Aufgabe ist:

1. Zielplattenauswahl direkt in HardwareCheck einbauen.
2. Handoff um Zielplatten-ID erweitern.
3. Acronis/Cyber Autostart so bauen, dass er nach doppelter Sicherheitsfreigabe `acrocmd recover disk` startet.
4. Erst danach echter Restore auf Testgeraet.
