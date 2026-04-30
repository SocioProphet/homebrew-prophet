# Agent Operating Instructions

Work issue-first.

Rules:
- One repo, one issue, one PR.
- Inspect the live repository before editing.
- Keep scope bounded to the issue body.
- Do not broaden scope without asking in the issue.
- Do not touch unrelated files.
- Do not claim production readiness unless acceptance criteria prove it.
- Include validation evidence in the PR body.
- Leave known gaps explicit.

PR body must include:
- What changed.
- Exact commands run.
- Pass/fail output summary.
- Known gaps.
- Anything blocked.

Never:
- Commit secrets, tokens, credentials, or private keys.
- Invent release URLs, checksums, SBOMs, or provenance.
- Invent SHA-256 values for release artifacts.
- Claim a formula is installable against a release that does not exist.

Homebrew tap-specific rules:
- Formula changes must include a test block.
- Placeholder formulas must clearly state what must be replaced at release time.
- Release-hash update workflows must consume actual release artifacts, not guessed values.
- Keep macOS/Linux support notes accurate.

Validation:
- Use Homebrew validation commands where available.
- At minimum, document the formula validation command in the PR body.
