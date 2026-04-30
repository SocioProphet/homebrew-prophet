# Homebrew Prophet

Homebrew tap for the SocioProphet, SourceOS, and Holmes product suite.

## Tap

```bash
brew tap SocioProphet/prophet
```

## Current formulae

```bash
brew install prophet-cli
brew install sourceos-ai
brew install holmes
```

`prophet-cli` installs the `prophet` facade command.

`sourceos-ai` installs the SourceOS local AI carry client.

`holmes` installs the Holmes language intelligence CLI.

## Dev formulae vs stable release formulae

This tap contains two kinds of formulae.

### Dev formulae (`Formula/*.rb`)

These build directly from the `main` branch of each upstream repository.
They are intended for local development and CI.  They carry a `-dev` version
suffix and do **not** pin a sha256 checksum (the source is a live git branch).

| Formula | Binary | Status |
|---|---|---|
| `prophet-cli.rb` | `prophet` | active |
| `sourceos-ai.rb` | `sourceos-ai` | active |
| `holmes.rb` | `holmes` | active |
| `model-router.rb` | `model-router` | active |
| `guardrail-fabric.rb` | `guardrail-fabric` | active |
| `model-governance-ledger.rb` | `model-governance-ledger` | active |
| `agent-registry.rb` | `agent-registry` | active |

### Stable release formulae (`Formula/<tool>@<version>.rb`)

These install from an **immutable release tarball** with a verified sha256
checksum.  They are intended for end-user production installs.

Release formulae are created from the templates in
[`Formula/templates/`](Formula/templates/README.md).  See that README for
step-by-step instructions, required inputs (version, URL, sha256,
SBOM/provenance references), and formula test requirements.

No stable release formulae have been published yet.  When a release is cut,
follow the template process to produce the versioned formula and open a PR
to this tap.

Available release templates:

| Template | Tool | Notes |
|---|---|---|
| `Formula/templates/model-router-release.rb` | model-router | |
| `Formula/templates/guardrail-fabric-release.rb` | guardrail-fabric | |
| `Formula/templates/agent-registry-release.rb` | agent-registry | |
| `Formula/templates/model-governance-ledger-release.rb` | model-governance-ledger | |
| `Formula/templates/nlboot-client-release.rb` | nlboot-client | Linux-only; dual-arch (x86\_64 + aarch64) |

For `nlboot-client`, trigger the
[update-nlboot-client](.github/workflows/update-nlboot-client.yml)
workflow with a published version string.  It downloads the release tarballs,
computes checksums, generates a versioned formula from the template, and opens
a PR automatically.

## Pending formulae

- `sourceos-devtools`
- `sourceos-installer`
- `nlplab`
- `embeddinglab`
- `graphlab`
- `timeserieslab`
- `imagelab`
- `speechlab`
- `ocrlab`
- `videolab`
- `translationlab`
