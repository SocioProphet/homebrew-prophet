#!/usr/bin/env python3
"""Generate a versioned nlboot-client release formula from the template.

Reads Formula/templates/nlboot-client-release.rb, replaces every
__PLACEHOLDER__ token with the supplied real values, and writes the result to
Formula/nlboot-client@VERSION.rb.

Usage:
    python3 tools/update_nlboot_client.py VERSION X86_URL X86_SHA ARM_URL ARM_SHA

Example:
    python3 tools/update_nlboot_client.py 0.2.0 \\
        https://github.com/SociOS-Linux/nlboot/releases/download/nlboot-client-v0.2.0/nlboot-client-nlboot-client-v0.2.0-x86_64-unknown-linux-gnu.tar.gz \\
        aabbcc0000000000000000000000000000000000000000000000000000000000 \\
        https://github.com/SociOS-Linux/nlboot/releases/download/nlboot-client-v0.2.0/nlboot-client-nlboot-client-v0.2.0-aarch64-unknown-linux-gnu.tar.gz \\
        ddeeff0000000000000000000000000000000000000000000000000000000000
"""
from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TEMPLATE = ROOT / "Formula" / "templates" / "nlboot-client-release.rb"


def fail(message: str) -> int:
    print(f"ERROR: {message}", file=sys.stderr)
    return 1


def main() -> int:
    if len(sys.argv) != 6:
        print(__doc__, file=sys.stderr)
        return fail("expected exactly 5 arguments: VERSION X86_URL X86_SHA ARM_URL ARM_SHA")

    version, x86_url, x86_sha, arm_url, arm_sha = sys.argv[1:]

    if not TEMPLATE.exists():
        return fail(f"template not found: {TEMPLATE}")

    text = TEMPLATE.read_text(encoding="utf-8")

    replacements = {
        "__VERSION__": version,
        "__X86_URL__": x86_url,
        "__X86_SHA256__": x86_sha,
        "__ARM_URL__": arm_url,
        "__ARM_SHA256__": arm_sha,
    }
    for placeholder, value in replacements.items():
        text = text.replace(placeholder, value)

    # Rename the class for the versioned formula.
    safe_version = version.replace(".", "_")
    text = text.replace(
        "class NlbootClientRelease < Formula",
        f"class NlbootClientAT{safe_version} < Formula",
    )

    out_path = ROOT / "Formula" / f"nlboot-client@{version}.rb"
    out_path.write_text(text, encoding="utf-8")
    print(f"Wrote {out_path}")
    print(f"  version : {version}")
    print(f"  x86_64  : {x86_sha}")
    print(f"  aarch64 : {arm_sha}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
