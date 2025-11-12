#!/usr/bin/env python3
# decrypt_simple.py - One-liner clean output
import sys
from pathlib import Path

XOR_KEY = 0xAB
enc_path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(r"C:\Temp\cdt_keylog.enc")
out_path = enc_path.with_suffix(".txt")

data = open(enc_path, "rb").read()
text = bytes(b ^ XOR_KEY for b in data).decode("utf-8", errors="replace")

with open(out_path, "w", encoding="utf-8") as f:
    for line in text.splitlines():
        if line.strip():
            f.write(line + "\n")

print(f"Decrypted → {out_path}")