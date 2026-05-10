---
paths:
  - **/.github/workflows/**/*.{yml,yaml}
---

# GitHub Actions Workflow Rules

These rules apply when creating or editing workflow files.

## Action SHA Pinning

When specifying third-party actions, **always pin to a full commit SHA**.
Tag references (`@v4`, etc.) are prohibited. Tags are mutable and pose a supply chain attack risk.

### How to Resolve SHAs

Use `resolve-gh-action-sha.sh` to get the latest version's commit SHA.

```bash
~/.claude/scripts/resolve-gh-action-sha.sh <owner/repo>
```

Output format: `owner/repo@<sha> # <version>`

### Format Requirements

Always add an inline comment after the SHA with the original version tag.

```yaml
# ✅ Correct
- uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
- uses: actions/setup-node@49933ea5288caeca8642d1e84afbd3f7d6820020 # v4.4.0

# ❌ Prohibited: tag references
- uses: actions/checkout@v4
- uses: actions/setup-node@v4
```

### Exceptions

SHA pinning is not required for:

- **Local actions**: `uses: ./`
- **Docker actions**: `uses: docker://`

### Workflow for Adding or Updating Actions

1. Run `resolve-gh-action-sha.sh` to obtain the SHA
2. Write the `uses:` entry with the full SHA
3. Append an inline comment with the version tag

## YAML Formatting

- Use 2-space indentation
- Only quote strings when necessary (e.g., values containing `${{ }}` expressions)
- Explicitly define `on:` trigger keys
- Provide a human-readable `name:` for every job and step
