Use the GitHub issue body as the source of truth.

Before editing:
1. Read the issue.
2. Inspect the repository.
3. Identify existing Homebrew formula patterns.
4. Keep the PR bounded.

When implementing:
- Do not invent release URLs or SHA-256 values.
- Prefer placeholder templates or release-update automation when artifacts do not exist yet.
- Add or preserve formula tests.
- Keep platform support notes accurate.
- Do not alter unrelated formulas or workflows.

When opening the PR:
- Link the issue.
- Include validation evidence.
- List known gaps.
- State non-goals preserved.
- Do not mark ready if validation did not run.
