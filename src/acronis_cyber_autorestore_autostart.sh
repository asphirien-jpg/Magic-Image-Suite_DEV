#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin
export PATH

LOG=/tmp/hc_acronis_autorestore.log
ACROCMD=/bin/acrocmd
HANDOFF_NAME=hardwarecheck_install_selection.json
SOURCE_DISK_DEFAULT=1

: > "$LOG" 2>/dev/null || LOG=/tmp/hc_acronis_autorestore_fallback.log

say() {
  echo "$@" | tee -a "$LOG"
}

fatal_to_gui() {
  say ""
  say "ABBRUCH: $*"
  say "Starte Acronis GUI zur manuellen Kontrolle..."
  sleep 8
  chvt 3 >/dev/null 2>&1
  while true; do sleep 3600; done
}

run_logged() {
  say ""
  say "### $*"
  "$@" 2>&1 | tee -a "$LOG"
  RC=$?
  say "### exit=$RC"
  return "$RC"
}

wait_for_acrocmd() {
  i=0
  if "$ACROCMD" list disks >/tmp/hc_acrocmd_ready.txt 2>&1; then
    return 0
  fi

  say "Starte Acronis Backend im Hintergrund..."
  chvt 3 >/dev/null 2>&1
  (/bin/product >/tmp/hc_product_background.log 2>&1 &)
  chvt 1 >/dev/null 2>&1

  while [ "$i" -lt 90 ]; do
    if "$ACROCMD" list disks >/tmp/hc_acrocmd_ready.txt 2>&1; then
      return 0
    fi
    i=$((i + 1))
    sleep 1
  done

  cat /tmp/hc_acrocmd_ready.txt >> "$LOG" 2>/dev/null
  return 1
}

mount_scan_volumes() {
  BASE=/mnt/hc_scan
  mkdir -p "$BASE"
  for dev in /dev/sd*[0-9] /dev/nvme*n*p[0-9] /dev/mmcblk*p[0-9]; do
    [ -b "$dev" ] || continue
    safe=$(echo "$dev" | sed 's#/#_#g')
    mp="$BASE/$safe"
    if mount | grep " $mp " >/dev/null 2>&1; then
      continue
    fi
    mkdir -p "$mp"
    mount -o ro "$dev" "$mp" >/dev/null 2>&1 \
      || mount.ntfs -o ro "$dev" "$mp" >/dev/null 2>&1 \
      || mount.ntfs-3g -o ro "$dev" "$mp" >/dev/null 2>&1 \
      || rmdir "$mp" >/dev/null 2>&1
  done
}

find_handoff() {
  rounds=0
  while [ "$rounds" -lt 20 ]; do
    mount_scan_volumes
    found=$(find /mnt /media /tmp -name "$HANDOFF_NAME" 2>/dev/null | head -n 1)
    if [ -n "$found" ]; then
      echo "$found"
      return 0
    fi
    rounds=$((rounds + 1))
    sleep 1
  done
  return 1
}

json_value() {
  key="$1"
  file="$2"
  sed -n "s/.*\"$key\"[ 	]*:[ 	]*\"\([^\"]*\)\".*/\1/p" "$file" | head -n 1
}

json_bool_true() {
  key="$1"
  file="$2"
  grep -E "\"$key\"[ 	]*:[ 	]*true" "$file" >/dev/null 2>&1
}

basename_any() {
  echo "$1" | sed 's#\\#/#g' | sed 's#.*/##'
}

loc_has_archive() {
  loc="$1"
  arc="$2"
  "$ACROCMD" list archives --loc="$loc" --filter_type=disk --output=raw >/tmp/hc_archives_probe.txt 2>/tmp/hc_archives_probe.err \
    || "$ACROCMD" list archives --loc="$loc" >/tmp/hc_archives_probe.txt 2>/tmp/hc_archives_probe.err
  cat /tmp/hc_archives_probe.txt /tmp/hc_archives_probe.err 2>/dev/null | grep -F "$arc" >/dev/null 2>&1
}

find_acronis_loc_for_archive() {
  arc="$1"
  for drive in F E G H I J K L M N O P Q R S T U V W X Y Z D C; do
    loc="${drive}:\\"
    if loc_has_archive "$loc" "$arc"; then
      echo "$loc"
      return 0
    fi
  done
  return 1
}

candidate_target_disks() {
  out="$1"
  awk '
    function flush_block() {
      if (disk == "") {
        return
      }
      upper = toupper(block)
      if (upper ~ /CYBER_TEST|HCDEBIAN|IMAGES|ACRONIS|ACRONIS_MEDIA|BOOTABLE BACKUP|PERSONAL VAULT/) {
        return
      }
      print disk
    }
    /^Disk [0-9]+:/ {
      flush_block()
      disk = $2
      gsub(":", "", disk)
      block = $0
      next
    }
    {
      block = block "\n" $0
    }
    END {
      flush_block()
    }
  ' "$out"
}

first_backup_name() {
  loc="$1"
  arc="$2"
  "$ACROCMD" list backups --loc="$loc" --arc="$arc" --output=raw >/tmp/hc_backups.txt 2>/tmp/hc_backups.err
  rc=$?
  cat /tmp/hc_backups.txt /tmp/hc_backups.err >> "$LOG" 2>/dev/null
  if [ "$rc" -ne 0 ]; then
    return 1
  fi
  awk '
    BEGIN { FS="[ \t]+" }
    /^[[:space:]]*$/ { next }
    /The operation completed successfully/ { next }
    /^type:/ { next }
    /^Name[[:space:]]/ { next }
    /^[-]+/ { next }
    { print $1; exit }
  ' /tmp/hc_backups.txt
}

main() {
  clear
  say "============================================================"
  say "HardwareCheck -> Acronis Cyber Auto-Restore"
  say "============================================================"
  say "Log: $LOG"
  say ""

  wait_for_acrocmd || fatal_to_gui "acrocmd wurde nicht bereit."

  HANDOFF=$(find_handoff)
  [ -n "$HANDOFF" ] || fatal_to_gui "Keine HardwareCheck-Handoff-Datei gefunden."
  HANDOFF_DIR=$(dirname "$HANDOFF")
  say "Handoff: $HANDOFF"

  if ! json_bool_true restore_automation_requested "$HANDOFF"; then
    if [ ! -f "$HANDOFF_DIR/restore_automation_requested.txt" ] || ! grep -q 1 "$HANDOFF_DIR/restore_automation_requested.txt"; then
      fatal_to_gui "Auto-Restore wurde nicht von HardwareCheck freigegeben."
    fi
  fi

  IMAGE_PATH=$(json_value recommended_image_path "$HANDOFF")
  ARC=$(basename_any "$IMAGE_PATH")
  [ -n "$ARC" ] || fatal_to_gui "Kein Image in Handoff eingetragen."

  LOC=$(find_acronis_loc_for_archive "$ARC")
  [ -n "$LOC" ] || fatal_to_gui "Acronis findet das gewaehlte Archiv nicht: $ARC"
  say "Archiv: $ARC"
  say "Location: $LOC"

  "$ACROCMD" list disks >/tmp/hc_disks.txt 2>&1
  cat /tmp/hc_disks.txt >> "$LOG"
  CANDIDATES=$(candidate_target_disks /tmp/hc_disks.txt | tr '\n' ' ')
  set -- $CANDIDATES
  if [ "$#" -ne 1 ]; then
    say "Acronis-Datentraeger:"
    cat /tmp/hc_disks.txt | tee -a "$LOG"
    fatal_to_gui "Zielplatte nicht eindeutig. Kandidaten: ${CANDIDATES:-keine}"
  fi
  TARGET_DISK="$1"
  say "Ziel-Disk: $TARGET_DISK"

  BACKUP=$(first_backup_name "$LOC" "$ARC")
  [ -n "$BACKUP" ] || fatal_to_gui "Backup im Archiv konnte nicht eindeutig gelesen werden."
  say "Backup: $BACKUP"

  SOURCE_DISK=$(json_value source_backup_disk "$HANDOFF")
  [ -n "$SOURCE_DISK" ] || SOURCE_DISK="$SOURCE_DISK_DEFAULT"
  say "Quelle im Backup: Disk $SOURCE_DISK"

  say ""
  say "STARTE AUTOMATISCHEN RESTORE."
  say "Quelle: $LOC / $ARC / Backup $BACKUP / Disk $SOURCE_DISK"
  say "Ziel:   Acronis Disk $TARGET_DISK"
  say ""
  sync

  run_logged "$ACROCMD" recover disk \
    --loc="$LOC" \
    --arc="$ARC" \
    --backup="$BACKUP" \
    --disk="$SOURCE_DISK" \
    --target_disk="$TARGET_DISK" \
    --progress \
    --log=/tmp/hc_acronis_recover_disk.log

  if [ "$?" -ne 0 ]; then
    fatal_to_gui "Restore ist fehlgeschlagen. Details siehe $LOG"
  fi

  say ""
  say "Restore abgeschlossen. Neustart in 15 Sekunden..."
  sleep 15
  reboot
}

main
