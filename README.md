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

## Linux-only formulae

```bash
brew install nlboot-client  # Linux only — errors on macOS
```

`nlboot-client` installs the SourceOS NLBoot signed boot/recovery client.
It drives kexec-based live and recovery flows and is **Linux-only**.
The formula uses release artifact tarballs from
[SociOS-Linux/nlboot](https://github.com/SociOS-Linux/nlboot/releases).

> **Updating sha256 hashes:** trigger the
> [update-nlboot-client](.github/workflows/update-nlboot-client.yml)
> workflow with the new version string after a release is published.
> That workflow downloads the release tarballs, computes checksums, and
> opens a PR updating the formula automatically.

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
