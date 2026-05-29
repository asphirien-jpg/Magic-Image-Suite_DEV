# Postinstall-Notizen

Stand: 2026-05-29

Postinstall wurde bisher nur grob betrachtet. Fokus des aktuellen Chats war Acronis/Cyber und HardwareCheck-Handoff.

## Ziel fuer Postinstall

Nach dem Windows-Restore soll das Postinstall-Skript automatisch wissen:

- welches Modell gewaehlt wurde
- welche Config genutzt werden soll
- welche Sprache/Image-Variante gewaehlt wurde
- ob ein fertiges Modellimage oder ein Magic/Rohimage verwendet wurde

Der Mitarbeiter soll nach dem Restore nicht erneut Modell/Config manuell auswaehlen muessen.

## Empfohlener Datenfluss

HardwareCheck schreibt auf Images-Partition:

`#handoff/hardwarecheck_install_selection.json`

Acronis/Cyber restored Windows.

Postinstall liest danach entweder:

- direkt von der Images-Partition, falls noch verbunden und Laufwerksbuchstabe bekannt
- oder aus einer Kopie im Windows-System, z.B. `C:\ProgramData\MagicImage\handoff.json`

## Empfehlung

Beim Restore oder direkt danach sollte der Handoff kopiert werden nach:

`C:\ProgramData\MagicImage\hardwarecheck_install_selection.json`

Dazu kann spaeter ein kleines FirstBoot-Skript genutzt werden.

## Inhalt fuer Postinstall

Wichtig fuer Postinstall:

```json
{
  "selected_model": "7770",
  "selected_language": "DE",
  "selected_image_profile": "MAGIC_IMAGE",
  "selected_config_path": "...",
  "selected_image_path": "...",
  "precheck_score": 40,
  "source": "HardwareCheck"
}
```

## Fertiges Modellimage vs Magic Image

Wenn ein fertiges modellspezifisches Image installiert wird:

- Postinstall muss eventuell weniger tun.
- Es soll aber trotzdem pruefen, ob es wirklich das richtige Geraet ist.

Wenn ein Magic/Rohimage installiert wird:

- Postinstall muss Config/Modell/Sprache aus Handoff lesen.
- Treiberinstallation und Addins/Config-Abgleich muessen automatisch laufen.

## Offene Punkte

- Wo genau startet aktuell das Treiberinstallationsskript?
- Wie heisst das aktuelle Postinstall-Hauptskript?
- Wo liegt der Addins/Config-Finalcheck?
- Kann Postinstall schon JSON lesen oder braucht es erst eine kleine Parser-Erweiterung?

## Empfehlung fuer neuen Chat

Postinstall erst anfassen, wenn der Restore-Handoff stabil ist. Danach mit einem kleinen JSON-Leser beginnen, der nur die Modellnummer und Config-Pfad ausgibt. Erst dann Treiber-/Finalcheck-Automation verbinden.
