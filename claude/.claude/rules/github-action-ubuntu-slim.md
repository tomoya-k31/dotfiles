---
paths:
  - "**/.github/workflows/**/*.{yml,yaml}"
---

# `ubuntu-slim` Runner Usage Policy

These rules apply when creating or editing workflow files.

## When to Use `runs-on: ubuntu-slim`

Adopt `ubuntu-slim` only when **all** of the following conditions are met:

| Condition | Criteria |
|---|---|
| No Docker | The job does not use a `container:` or `services:` block |
| No privileged operations | No filesystem mounts, Docker-in-Docker, kernel modules, or similar |
| Lightweight job | The job is centered on API calls via tools like `gh`, `curl`, `jq` |
| No multi-core requirement | The job completes in an acceptable time on 1 vCPU |
| Non-blocking for releases | A failure does not halt the release pipeline itself (a Preview-state risk is acceptable) |

If even one condition is not met, continue using `ubuntu-latest`.

## How to Apply

- Before setting `runs-on:` on a job, check the job's actions against the table above.
- Default to `ubuntu-latest` when in doubt — `ubuntu-slim` is an opt-in optimization, not the default.
