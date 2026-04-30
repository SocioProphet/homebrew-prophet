#!/usr/bin/env python3
"""Rewrite nlboot-client formula with release artifact URLs and sha256 hashes.

Usage:
    python3 tools/update_nlboot_client.py VERSION X86_URL X86_SHA ARM_URL ARM_SHA

Example:
    python3 tools/update_nlboot_client.py 0.2.0 \\
        https://github.com/SociOS-Linux/nlboot/releases/download/nlboot-client-v0.2.0/nlboot-client-nlboot-client-v0.2.0-x86_64-unknown-linux-gnu.tar.gz \\
        aabbcc... \\
        https://github.com/SociOS-Linux/nlboot/releases/download/nlboot-client-v0.2.0/nlboot-client-nlboot-client-v0.2.0-aarch64-unknown-linux-gnu.tar.gz \\
        ddeeff...
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FORMULA = ROOT / "Formula" / "nlboot-client.rb"


def fail(message: str) -> int:
    print(f"ERROR: {message}", file=sys.stderr)
    return 1


def main() -> int:
    if len(sys.argv) != 6:
        print(__doc__, file=sys.stderr)
        return fail("expected exactly 5 arguments: VERSION X86_URL X86_SHA ARM_URL ARM_SHA")

    version, x86_url, x86_sha, arm_url, arm_sha = sys.argv[1:]

    if not FORMULA.exists():
        return fail(f"formula not found: {FORMULA}")

    text = FORMULA.read_text(encoding="utf-8")

    # Update the version string.
    text = re.sub(r'version "[^"]+"', f'version "{version}"', text)

    # Update x86_64 URL and its sha256.
    text = re.sub(
        r'url "https://github\.com/SociOS-Linux/nlboot/releases/download/[^"]*x86_64[^"]+\.tar\.gz"',
        f'url "{x86_url}"',
        text,
    )
    text = re.sub(
        r'sha256 "(?:REPLACE_WITH_X86_64_SHA256|[0-9a-f]{64})"(\s*#.*)?(\s*else)',
        lambda m: f'sha256 "{x86_sha}"{m.group(1) or ""}{m.group(2)}',
        text,
    )

    # Update aarch64 URL and its sha256.
    text = re.sub(
        r'url "https://github\.com/SociOS-Linux/nlboot/releases/download/[^"]*aarch64[^"]+\.tar\.gz"',
        f'url "{arm_url}"',
        text,
    )
    text = re.sub(
        r'sha256 "(?:REPLACE_WITH_AARCH64_SHA256|[0-9a-f]{64})"(\s*#.*)?(\s*end)',
        lambda m: f'sha256 "{arm_sha}"{m.group(1) or ""}{m.group(2)}',
        text,
    )

    FORMULA.write_text(text, encoding="utf-8")
    print(f"Updated {FORMULA} to version {version}")
    print(f"  x86_64  sha256: {x86_sha}")
    print(f"  aarch64 sha256: {arm_sha}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
