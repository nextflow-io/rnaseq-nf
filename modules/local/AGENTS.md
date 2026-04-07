# AGENTS.md

## Purpose

This directory contains project-local process modules used by the example pipeline.

## Editing guidance

- Keep modules focused on a single process.
- Avoid pipeline-level orchestration here; put cross-module coordination in `subworkflows/`.
- Preserve emitted value shapes unless the corresponding callers and tests are updated in the same change.
- Keep module-specific notes in the module's own `AGENTS.md`.
