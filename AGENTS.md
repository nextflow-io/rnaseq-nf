# AGENTS.md

## Purpose

This repository contains `rnaseq-nf`, a small example Nextflow RNA-seq pipeline used as a reference project and cleanup target for agentic-readiness improvements.

## Goals for agent edits

When making changes here, prefer:

1. small, reviewable commits
2. behavior-preserving cleanups before semantic refactors
3. explicit tests or validation steps for any workflow change
4. modern Nextflow syntax and structure where practical
5. changes that improve machine-readability for future agent runs

## Commit policy

Make **one commit per logical fix**. Do not bundle unrelated cleanups together.

## Repository map

- `main.nf` — top-level pipeline entrypoint
- `nextflow.config` — pipeline config, manifest, and execution profiles
- `subworkflows/local/rnaseq/main.nf` — orchestrating subworkflow used by `main.nf`
- `modules/local/*/main.nf` — process modules (`fastqc`, `index`, `quant`, `multiqc`)
- `nextflow_schema.json` — pipeline parameter schema
- `.github/workflows/build.yml` — CI workflow
- `multiqc/` — MultiQC assets/config
- `data/ggal/` — example input data
- `docker/` — container build assets

## Local validation

Use the repo root as the working directory.

### Basic pipeline run

```bash
nextflow run . -profile docker
```

### Wave profile

```bash
nextflow run . -profile docker,wave
```

### Common checks after edits

After modifying workflow code, prefer to run:

```bash
git diff --stat
nextflow run . -profile docker
```

If you touch CI, also inspect:

```bash
sed -n '1,220p' .github/workflows/build.yml
```

## Agentic-readiness focus areas

When auditing or modernizing this repository, check for:

- presence and quality of repo guidance files (`AGENTS.md`, `.nf-core.yml`)
- test coverage (including `nf-test` if introduced)
- strict-syntax blockers and legacy syntax patterns
- typed inputs/outputs and newer Nextflow constructs where appropriate
- schema completeness (`nextflow_schema.json`, input schema if added)
- clear structure that is easy for both humans and agents to scan

## Editing guidance

- Preserve existing behavior unless the change explicitly intends to modernize behavior.
- Avoid broad renames or restructures without a clear follow-up plan.
- Keep docs aligned with actual commands and file locations.
- Prefer deterministic, cheap-to-compute signals that a scanner could later reuse.
- Call out any discovered legacy patterns in commit messages or follow-up notes.

## Known current modernization candidates

These are known areas worth addressing incrementally:

- missing `.nf-core.yml`
- no `nf-test` scaffolding yet
- likely strict-syntax blocker in `main.nf` (`workflow.onComplete = { ... }`)
- older module/layout conventions compared with newer Nextflow examples

## If you are an agent starting fresh

1. Read this file.
2. Inspect `main.nf`, `nextflow.config`, and `.github/workflows/build.yml`.
3. Check `git status` before editing.
4. Make only one logical fix at a time.
5. Validate the specific change.
6. Commit before moving to the next cleanup.
