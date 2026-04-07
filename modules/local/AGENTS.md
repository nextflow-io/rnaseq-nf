# AGENTS.md

## Purpose

This directory contains project-local process modules used by the example pipeline.

## Layout

- one process module per subdirectory
- each module entrypoint lives at `main.nf`
- module-specific guidance belongs in that module's own `AGENTS.md`

## Editing guidance

- Keep modules focused on a single process.
- Prefer typed inputs and outputs.
- Avoid pipeline-level orchestration here; put cross-module coordination in `subworkflows/`.
- Preserve emitted value shapes unless the corresponding callers and tests are updated in the same change.

## Validation

From the repo root, prefer:

```bash
NXF_SYNTAX_PARSER=v2 nextflow lint .
nf-test test tests/default/main.nf.test
```
