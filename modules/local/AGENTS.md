---
purpose: Guide edits to project-local process modules.
applies_to: modules/local/
entrypoint: Each module's main.nf.
verification: NXF_VER=26.04.6 nf-test test --profile wave tests/default/main.nf.test
update_when: Module contracts or layout change.
---

# AGENTS.md

## Purpose

This directory contains project-local process modules used by the example pipeline.

## Editing guidance

- Keep modules focused on a single process.
- Avoid pipeline-level orchestration here; put cross-module coordination in `subworkflows/`.
- Preserve emitted value shapes unless the corresponding callers and tests are updated in the same change.
- Keep module-specific notes in the module's own `AGENTS.md`.
