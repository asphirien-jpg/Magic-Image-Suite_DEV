# Magic Image Suite DEV

Dieses Repository ist das Uebergabe- und Entwicklungsprotokoll fuer den aktuellen Ablauf:

`Debian/HardwareCheck -> Acronis Cyber Protect -> Windows/Postinstall`

Ziel ist, dass ein neuer Chat sofort versteht, was gebaut wurde, was getestet wurde, was offen ist und wo das Risiko liegt.

## Wichtig

Dieses Repo enthaelt bewusst keine produktiven Images, keine Acronis-Programmdateien, keine Boot-Ramdisks und keine Lizenzdaten.

Nicht hochgeladen werden:

- `.tib` oder `.tibx` Images
- Acronis/Cyber/SnapDeploy Installationsdateien
- originale oder gepatchte `ramdisk2.dat`
- extrahierte Acronis-Dateien
- Lizenz- oder Accountdaten

## Schnellstart fuer einen neuen Chat

1. `docs/QUICKSTART_NEUER_CHAT.md` lesen.
2. `docs/UEBERGABE_NEUER_CHAT_2026-05-29.md` lesen.
3. `docs/SICHERHEIT_UND_RISIKEN.md` lesen, bevor Restore-Logik angefasst wird.
4. `docs/TESTPROTOKOLL_2026-05-29.md` lesen, um den bisherigen Verlauf zu verstehen.
5. Aktive lokale Dateien gegen `docs/DATEIEN_UND_HASHES.md` pruefen.

## Aktueller Stand

- HardwareCheck InstallTool MVP steht bei `install-mvp-0.8`.
- Debian/HardwareCheck findet Configs und Images auf getrennten Laufwerken.
- Modellnummer-Eingabe funktioniert.
- Image-Auswahl funktioniert.
- Handoff-Datei auf der Images-Partition wird geschrieben.
- BootNext von Debian nach Acronis/Cyber funktioniert.
- Acronis Cyber Protect Linux sieht die Archive und Datentraeger.
- Ein Cyber-Autostart fuer `acrocmd` wurde vorbereitet, ist aber noch nicht als echter Restore-Endlauf verifiziert.

## Wichtigste Bewertung

Acronis True Image 2021 eignet sich als GUI-Fallback, aber nicht als saubere Vollautomatisierung.

Snap Deploy 6 ist wegen `.tibx`-Problemen fuer unsere VMD-Images nicht ausreichend.

Acronis Cyber Protect mit Linux-Bootmedium und `acrocmd` ist aktuell der beste Kandidat fuer Automatisierung, aber der automatische Restore muss noch mit Testgeraet/Testplatte final validiert werden.
