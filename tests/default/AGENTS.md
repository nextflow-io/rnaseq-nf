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
nf-test test tests/default/main.nf.test
```

To intentionally refresh snapshots:

```bash
nf-test test --update-snapshot tests/default/main.nf.test
```

The default test uses the `conda` profile from `nf-test.config` and executes the real pipeline rather than a stub run.

## Scope

`main.nf.test` is meant to cover the default bundled example data path for the full pipeline. Keep deeper module-specific assertions in separate tests.
