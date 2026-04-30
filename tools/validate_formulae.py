#!/usr/bin/env python3
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
FORMULA_DIR = ROOT / "Formula"
TEMPLATE_DIR = FORMULA_DIR / "templates"

# Source-built development formulae (track git main branch; no sha256 required).
REQUIRED = {
    "prophet-cli.rb": "prophet",
    "sourceos-ai.rb": "sourceos-ai",
    "holmes.rb": "holmes",
    "model-router.rb": "model-router",
    "guardrail-fabric.rb": "guardrail-fabric",
    "model-governance-ledger.rb": "model-governance-ledger",
    "agent-registry.rb": "agent-registry",
}

# Immutable release artifact formula templates (placeholders only; no real URLs/checksums).
TEMPLATE_REQUIRED = {
    "model-router-release.rb": "model-router",
    "guardrail-fabric-release.rb": "guardrail-fabric",
    "agent-registry-release.rb": "agent-registry",
    "model-governance-ledger-release.rb": "model-governance-ledger",
    "nlboot-client-release.rb": "nlboot-client",
}

# Every placeholder that must appear in each template file.
# Templates that use non-standard placeholders can override this via
# TEMPLATE_PLACEHOLDERS; all others use REQUIRED_PLACEHOLDERS.
REQUIRED_PLACEHOLDERS = [
    "__VERSION__",
    "__URL__",
    "__SHA256__",
    "__SBOM_URL__",
    "__SBOM_SHA256__",
]

# Per-template placeholder overrides (used instead of REQUIRED_PLACEHOLDERS).
# nlboot-client ships separate tarballs for x86_64 and aarch64.
TEMPLATE_PLACEHOLDERS: dict[str, list[str]] = {
    "nlboot-client-release.rb": [
        "__VERSION__",
        "__X86_URL__",
        "__X86_SHA256__",
        "__ARM_URL__",
        "__ARM_SHA256__",
        "__SBOM_URL__",
        "__SBOM_SHA256__",
    ],
}

FORMULA_TOKENS = ["class ", " desc ", " homepage ", " url ", " version ", " def install", " test do", "end"]


def fail(message: str) -> int:
    print(f"ERROR: {message}", file=sys.stderr)
    return 1


def validate_dev_formulae() -> int:
    if not FORMULA_DIR.exists():
        return fail("Formula directory is missing")
    for filename, binary in REQUIRED.items():
        path = FORMULA_DIR / filename
        if not path.exists():
            return fail(f"missing formula: {filename}")
        text = path.read_text(encoding="utf-8")
        for needle in FORMULA_TOKENS:
            if needle not in text:
                return fail(f"{filename}: missing required formula token {needle!r}")
        if binary not in text:
            return fail(f"{filename}: expected binary/name token {binary!r}")
        if re.search(r"sha256\s+\"(0+|TODO|TBD)", text, re.IGNORECASE):
            return fail(f"{filename}: fake sha256 detected")
        if "github.com" not in text:
            return fail(f"{filename}: missing GitHub source URL")
    return 0


def validate_templates() -> int:
    if not TEMPLATE_DIR.exists():
        return fail("Formula/templates directory is missing")
    for filename, binary in TEMPLATE_REQUIRED.items():
        path = TEMPLATE_DIR / filename
        if not path.exists():
            return fail(f"missing template: templates/{filename}")
        text = path.read_text(encoding="utf-8")
        for needle in FORMULA_TOKENS:
            if needle not in text:
                return fail(f"templates/{filename}: missing required formula token {needle!r}")
        if binary not in text:
            return fail(f"templates/{filename}: expected binary/name token {binary!r}")
        placeholders = TEMPLATE_PLACEHOLDERS.get(filename, REQUIRED_PLACEHOLDERS)
        for placeholder in placeholders:
            if placeholder not in text:
                return fail(f"templates/{filename}: missing required placeholder {placeholder!r}")
        # Templates must NOT contain real (64-char hex) sha256 values.
        if re.search(r'sha256\s+"[0-9a-f]{64}"', text):
            return fail(f"templates/{filename}: real sha256 value detected (use __SHA256__ placeholder)")
        # Templates must NOT contain obviously fake sha256 values either.
        if re.search(r"sha256\s+\"(0+|TODO|TBD)", text, re.IGNORECASE):
            return fail(f"templates/{filename}: fake sha256 detected")
        if "github.com" not in text:
            return fail(f"templates/{filename}: missing GitHub URL")
    return 0


def main() -> int:
    rc = validate_dev_formulae()
    if rc != 0:
        return rc
    rc = validate_templates()
    if rc != 0:
        return rc
    print(
        f"OK: validated {len(REQUIRED)} dev formulae "
        f"and {len(TEMPLATE_REQUIRED)} release formula templates"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
