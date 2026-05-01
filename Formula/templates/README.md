# Release Formula Templates

This directory contains **immutable release artifact formula templates** for the
model-fabric tools.  These templates are intentionally left with placeholder
tokens and are **not** installed directly by `brew install`.

## What these templates are for

| Template file | Tool | Notes |
|---|---|---|
| `model-router-release.rb` | model-router | |
| `guardrail-fabric-release.rb` | guardrail-fabric | |
| `agent-registry-release.rb` | agent-registry | |
| `model-governance-ledger-release.rb` | model-governance-ledger | |
| `nlboot-client-release.rb` | nlboot-client | Linux-only; dual-arch (x86\_64 + aarch64); see [NLBoot handoff](#nlboot-nlboot-client-release-handoff) |

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

Most templates use the following standard tokens.  **Replace all of them**
before publishing the formula.

| Token | Description |
|---|---|
| `__VERSION__` | Semantic version string, e.g. `1.2.3` |
| `__URL__` | Download URL of the release tarball (from GitHub Releases) |
| `__SHA256__` | SHA-256 checksum of the release tarball |
| `__SBOM_URL__` | Download URL of the SBOM artifact for this release |
| `__SBOM_SHA256__` | SHA-256 checksum of the SBOM artifact |

`nlboot-client` ships separate binaries for x86\_64 and aarch64 and uses these
tokens instead of `__URL__` / `__SHA256__`:

| Token | Description |
|---|---|
| `__VERSION__` | Semantic version string, e.g. `0.1.0` |
| `__X86_URL__` | Download URL of the x86\_64 release tarball |
| `__X86_SHA256__` | SHA-256 checksum of the x86\_64 release tarball |
| `__ARM_URL__` | Download URL of the aarch64 release tarball |
| `__ARM_SHA256__` | SHA-256 checksum of the aarch64 release tarball |
| `__SBOM_URL__` | Download URL of the SPDX SBOM artifact |
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
5. Verify the provenance attestation out-of-band.
6. Run `make validate` to confirm the formula passes structural checks.
7. Open a pull request with only the new versioned formula file.

## SBOM and provenance requirements

Each stable release formula must reference:

- **SBOM** – an SBOM artifact attached to the GitHub Release. For NLBoot, the
  release workflow emits target-specific SPDX JSON artifacts named
  `nlboot-client-<version>-<target>-sbom.spdx.json`. Record the download URL
  and sha256 in the `resource "sbom"` block of the formula.
- **Provenance attestation** – a GitHub build-provenance attestation attached
  to the same release where GitHub supports it. Verify it before publishing
  the formula. The attestation URL may be noted in a formula comment for
  auditability.

## Formula tests

Every release formula must include a `test do` block that exercises the
installed binary.  At a minimum the test should assert that:

- The binary exits successfully (`system` or `assert_predicate`).
- The binary identifies itself with the correct tool name or version string
  (`assert_match`).

See the templates for example `test do` blocks.

---

## NLBoot (`nlboot-client`) release handoff

`nlboot-client` requires extra steps compared with other tools because it ships
separate Linux binaries for x86\_64 and aarch64.  Formula generation is
automated via the
[`update-nlboot-client`](../../.github/workflows/update-nlboot-client.yml)
workflow.  Follow the steps below every time a tagged NLBoot release is
published at `https://github.com/SociOS-Linux/nlboot/releases`.

> **Do NOT start until a real tagged release exists.**  Do not invent URLs,
> checksums, or artifact names.

### Required artifacts checklist

Before triggering the workflow or running the helper script, confirm that the
GitHub Release for `nlboot-client-v<VERSION>` includes **all** of the following:

- [ ] Linux x86\_64 tarball:
      `nlboot-client-nlboot-client-v<VERSION>-x86_64-unknown-linux-gnu.tar.gz`
- [ ] Linux aarch64 tarball:
      `nlboot-client-nlboot-client-v<VERSION>-aarch64-unknown-linux-gnu.tar.gz`
- [ ] Checksum file: `SHA256SUMS` (must cover both tarballs and SBOM files)
- [ ] x86\_64 SPDX SBOM file:
      `nlboot-client-nlboot-client-v<VERSION>-x86_64-unknown-linux-gnu-sbom.spdx.json`
- [ ] x86\_64 SPDX SBOM checksum:
      `nlboot-client-nlboot-client-v<VERSION>-x86_64-unknown-linux-gnu-sbom.spdx.json.sha256`
- [ ] aarch64 SPDX SBOM file:
      `nlboot-client-nlboot-client-v<VERSION>-aarch64-unknown-linux-gnu-sbom.spdx.json`
- [ ] aarch64 SPDX SBOM checksum:
      `nlboot-client-nlboot-client-v<VERSION>-aarch64-unknown-linux-gnu-sbom.spdx.json.sha256`

Do not proceed until every item is present on the release page.

### Step 1 – Trigger the automated workflow (recommended)

From the GitHub Actions UI, navigate to
**Actions → update-nlboot-client → Run workflow** and enter the version string
(without a leading `v`, e.g. `0.1.0`).

Alternatively, use the `gh` CLI:

```bash
gh workflow run update-nlboot-client.yml \
  --repo SocioProphet/homebrew-prophet \
  --field version=<VERSION>
```

The workflow will:

1. Download the x86\_64 and aarch64 release tarballs.
2. Compute SHA-256 checksums from the downloaded artifacts.
3. Generate `Formula/nlboot-client@<VERSION>.rb` from the template.
4. Open a pull request automatically.

### Step 2 – Manual fallback (if the workflow is unavailable)

Download the two tarballs and compute their SHA-256 values:

```bash
curl -fsSL -o nlboot-x86.tar.gz \
  "https://github.com/SociOS-Linux/nlboot/releases/download/nlboot-client-v<VERSION>/nlboot-client-nlboot-client-v<VERSION>-x86_64-unknown-linux-gnu.tar.gz"
curl -fsSL -o nlboot-arm.tar.gz \
  "https://github.com/SociOS-Linux/nlboot/releases/download/nlboot-client-v<VERSION>/nlboot-client-nlboot-client-v<VERSION>-aarch64-unknown-linux-gnu.tar.gz"

sha256sum nlboot-x86.tar.gz nlboot-arm.tar.gz
```

Cross-check both values against the upstream `SHA256SUMS` file:

```bash
curl -fsSL \
  "https://github.com/SociOS-Linux/nlboot/releases/download/nlboot-client-v<VERSION>/SHA256SUMS" \
  | sha256sum --check --ignore-missing
```

Then run the helper script:

```bash
python3 tools/update_nlboot_client.py <VERSION> \
  <X86_URL> <X86_SHA256> \
  <ARM_URL> <ARM_SHA256>
```

### Step 3 – Add the SBOM resource block

The generated formula contains a commented-out `resource "sbom"` block. Use the
SBOM for the same target family that the formula installs. For the first Linux
formula, prefer the x86\_64 SBOM unless the generated formula is target-specific.

Obtain the SBOM SHA-256:

```bash
curl -fsSL -o nlboot-sbom.spdx.json \
  "https://github.com/SociOS-Linux/nlboot/releases/download/nlboot-client-v<VERSION>/nlboot-client-nlboot-client-v<VERSION>-x86_64-unknown-linux-gnu-sbom.spdx.json"
sha256sum nlboot-sbom.spdx.json
```

Then uncomment and fill in the block inside the generated formula:

```ruby
resource "sbom" do
  url "https://github.com/SociOS-Linux/nlboot/releases/download/nlboot-client-v<VERSION>/nlboot-client-nlboot-client-v<VERSION>-x86_64-unknown-linux-gnu-sbom.spdx.json"
  sha256 "<SBOM_SHA256>"
end
```

### Step 4 – Validate

```bash
make validate
```

`make validate` runs `python3 tools/validate_formulae.py`, which checks:

- All dev formulae have the required Ruby structure and no fake sha256 values.
- All release templates contain required placeholder tokens and no real sha256 values.
- The generated formula is **not** validated by this command (it lives in
  `Formula/`, not `Formula/templates/`); use `brew audit` for that.

On a Linux host with Homebrew installed, run additional structural checks on
the generated formula:

```bash
brew audit --strict Formula/nlboot-client@<VERSION>.rb
```

### Step 5 – Open a pull request

If you used the automated workflow the PR is opened automatically.  If you ran
the manual steps, push only the generated formula file and open a PR:

```
Formula/nlboot-client@<VERSION>.rb
```

The PR must not include changes to the template file, the helper script, or
any dev formula.
