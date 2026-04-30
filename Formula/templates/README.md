# Release Formula Templates

This directory contains **immutable release artifact formula templates** for the
model-fabric tools.  These templates are intentionally left with placeholder
tokens and are **not** installed directly by `brew install`.

## What these templates are for

| Template file | Tool |
|---|---|
| `model-router-release.rb` | model-router |
| `guardrail-fabric-release.rb` | guardrail-fabric |
| `agent-registry-release.rb` | agent-registry |
| `model-governance-ledger-release.rb` | model-governance-ledger |

## Dev formulae vs stable release formulae

| | Dev formulae (`Formula/*.rb`) | Release formulae (from these templates) |
|---|---|---|
| Source | Git `main` branch | Immutable release tarball |
| sha256 | None (tracks branch HEAD) | Real sha256 of the release tarball |
| Versioning | `0.x.x-dev` | Semantic version, e.g. `1.2.3` |
| Use | Local development and CI | End-user production installs |

The dev formulae in `Formula/` are **not modified** when a release is cut.
Instead, copy the appropriate template and fill in real values to produce a
versioned release formula.

## Placeholder tokens

Every template uses the following tokens.  **Replace all of them** before
publishing the formula.

| Token | Description |
|---|---|
| `__VERSION__` | Semantic version string, e.g. `1.2.3` |
| `__URL__` | Download URL of the release tarball (from GitHub Releases) |
| `__SHA256__` | SHA-256 checksum of the release tarball |
| `__SBOM_URL__` | Download URL of the CycloneDX SBOM artifact for this release |
| `__SBOM_SHA256__` | SHA-256 checksum of the SBOM artifact |

> **Do NOT invent URLs or checksums.**  Obtain them from the official GitHub
> Release page for each tool.  Publishing a formula with placeholder tokens or
> fabricated values will break `brew install` for all users.

## How to create a release formula from a template

1. Wait for the upstream GitHub Release to be published and all release assets
   (tarball, SBOM, provenance attestation) to be attached.
2. Copy the relevant template:
   ```bash
   cp Formula/templates/model-router-release.rb Formula/model-router@1.2.3.rb
   ```
3. Replace every `__PLACEHOLDER__` token with the real value:
   ```bash
   # Example – use the actual values from the GitHub Release page
   sed -i 's|__VERSION__|1.2.3|g'  Formula/model-router@1.2.3.rb
   sed -i 's|__URL__|https://...|g' Formula/model-router@1.2.3.rb
   sed -i 's|__SHA256__|abc123...|g' Formula/model-router@1.2.3.rb
   ```
4. Uncomment the `resource "sbom"` block and fill in `__SBOM_URL__` and
   `__SBOM_SHA256__`.
5. Verify the provenance attestation out-of-band (e.g. with `cosign verify-blob`).
6. Run `make validate` to confirm the formula passes structural checks.
7. Open a pull request with only the new versioned formula file.

## SBOM and provenance requirements

Each stable release formula must reference:

- **SBOM** – a CycloneDX SBOM artifact (`sbom.cdx.json`) attached to the
  GitHub Release.  Record the download URL and sha256 in the `resource "sbom"`
  block of the formula.
- **Provenance attestation** – a cosign-signed SLSA provenance attestation
  (`attestation.json`) attached to the same release.  Verify it before
  publishing the formula.  The attestation URL may be noted in a formula
  comment for auditability.

## Formula tests

Every release formula must include a `test do` block that exercises the
installed binary.  At a minimum the test should assert that:

- The binary exits successfully (`system` or `assert_predicate`).
- The binary identifies itself with the correct tool name or version string
  (`assert_match`).

See the templates for example `test do` blocks.
