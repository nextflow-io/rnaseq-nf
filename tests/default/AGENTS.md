---
purpose: Guide the default end-to-end smoke test.
applies_to: tests/default/
entrypoint: main.nf.test
verification: NXF_VER=26.04.6 nf-test test --profile wave tests/default/main.nf.test
update_when: Smoke-test scope, fixtures, or snapshots change.
---

# AGENTS.md

## Purpose

This directory contains the default `nf-test` smoke coverage for `main.nf`.

## Conventions

- Keep tests fast and deterministic.
- Prefer smoke coverage that validates successful execution and the expected top-level output set.
- Store snapshots next to the test file.
- Update snapshots only when the output shape intentionally changes.

## Running the test

From the repository root:

```bash
NXF_VER=26.04.6 nf-test test --profile wave tests/default/main.nf.test
```

To intentionally refresh snapshots:

```bash
NXF_VER=26.04.6 nf-test test --profile wave --update-snapshot tests/default/main.nf.test
```

The default test executes the real pipeline using the repository's default config rather than a stub run.

## Scope

`main.nf.test` is meant to cover the default bundled example data path for the full pipeline. Keep deeper module-specific assertions in separate tests.
