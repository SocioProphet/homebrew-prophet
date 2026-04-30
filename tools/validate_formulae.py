#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FORMULA_DIR = ROOT / "Formula"
REQUIRED = {
    "prophet-cli.rb": "prophet",
    "sourceos-ai.rb": "sourceos-ai",
    "holmes.rb": "holmes",
    "model-router.rb": "model-router",
    "guardrail-fabric.rb": "guardrail-fabric",
    "model-governance-ledger.rb": "model-governance-ledger",
    "agent-registry.rb": "agent-registry",
    "nlboot-client.rb": "nlboot-client",
}


def fail(message: str) -> int:
    print(f"ERROR: {message}", file=sys.stderr)
    return 1


def main() -> int:
    if not FORMULA_DIR.exists():
        return fail("Formula directory is missing")
    for filename, binary in REQUIRED.items():
        path = FORMULA_DIR / filename
        if not path.exists():
            return fail(f"missing formula: {filename}")
        text = path.read_text(encoding="utf-8")
        for needle in ["class ", " desc ", " homepage ", " url ", " version ", " def install", " test do", "end"]:
            if needle not in text:
                return fail(f"{filename}: missing required formula token {needle!r}")
        if binary not in text:
            return fail(f"{filename}: expected binary/name token {binary!r}")
        if re.search(r"sha256\s+\"(0+|TODO|TBD)", text, re.IGNORECASE):
            return fail(f"{filename}: fake sha256 detected")
        if "github.com" not in text:
            return fail(f"{filename}: missing GitHub source URL")
    print(f"OK: validated {len(REQUIRED)} Homebrew formulae")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
