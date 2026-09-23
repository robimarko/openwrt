#!/usr/bin/env python3
"""Generate a U-Boot console script that uploads a file with mw.l.

The generated commands reconstruct the input byte-for-byte at the requested
RAM address on a little-endian target such as the IPQ9574.  The last word is
zero-padded; use the emitted filesize value when consuming the payload.
"""

import argparse
import binascii
import struct
from pathlib import Path


def emit_words(data: bytes, address: int, max_repeat: int) -> None:
    padded = data + b"\0" * ((-len(data)) % 4)
    words = [struct.unpack_from("<I", padded, offset)[0]
             for offset in range(0, len(padded), 4)]

    index = 0
    while index < len(words):
        value = words[index]
        count = 1
        while (index + count < len(words) and words[index + count] == value
               and count < max_repeat):
            count += 1
        print(f"mw.l 0x{address + index * 4:08x} 0x{value:08x} 0x{count:x}")
        index += count


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generate paced-safe U-Boot mw.l upload commands")
    parser.add_argument("file", type=Path, help="binary file to upload")
    parser.add_argument("--address", type=lambda value: int(value, 0),
                        default=0x41000000, help="destination RAM address")
    parser.add_argument("--max-repeat", type=lambda value: int(value, 0),
                        default=0x400,
                        help="maximum same-word fill count per mw.l command")
    args = parser.parse_args()

    if args.address & 3:
        parser.error("--address must be 4-byte aligned")
    if args.max_repeat < 1:
        parser.error("--max-repeat must be positive")

    data = args.file.read_bytes()
    crc = binascii.crc32(data) & 0xffffffff

    print(f"setenv filesize 0x{len(data):x}")
    emit_words(data, args.address, args.max_repeat)
    print(f"echo Expected_CRC32=0x{crc:08x}")
    print(f"crc32 0x{args.address:08x} ${{filesize}}")


if __name__ == "__main__":
    main()
