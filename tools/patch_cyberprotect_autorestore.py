from __future__ import annotations

import argparse
import dataclasses
import lzma
from pathlib import Path

from patch_cyberprotect_ramdisk2_autostart import Entry, parse_newc, write_newc


def remove_existing(entries: list[Entry], name: str) -> None:
    entries[:] = [entry for entry in entries if entry.name != name]


def insert_after(entries: list[Entry], after_name: str, entry: Entry) -> None:
    remove_existing(entries, entry.name)
    for index, current in enumerate(entries):
        if current.name == after_name:
            entries.insert(index + 1, entry)
            return
    entries.append(entry)


def patch_ramdisk(source: Path, autostart: Path, destination: Path) -> None:
    original = source.read_bytes()
    entries = parse_newc(lzma.decompress(original))

    root = next(entry for entry in entries if entry.name == "ConfigurationFiles")
    mtime = root.mtime

    bin_dir = dataclasses.replace(
        root,
        name="ConfigurationFiles/bin",
        data=b"",
        mode=0o40755,
        nlink=2,
        mtime=mtime,
    )
    autostart_entry = dataclasses.replace(
        root,
        name="ConfigurationFiles/bin/autostart",
        data=autostart.read_bytes(),
        mode=0o100644,
        nlink=1,
        mtime=mtime,
    )

    insert_after(entries, "ConfigurationFiles", bin_dir)
    insert_after(entries, "ConfigurationFiles/bin", autostart_entry)

    payload = write_newc(entries)
    destination.write_bytes(lzma.compress(payload, preset=6, format=lzma.FORMAT_XZ))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("autostart", type=Path)
    parser.add_argument("destination", type=Path)
    args = parser.parse_args()
    patch_ramdisk(args.source, args.autostart, args.destination)


if __name__ == "__main__":
    main()
