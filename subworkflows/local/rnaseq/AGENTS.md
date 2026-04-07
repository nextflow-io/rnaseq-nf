# AGENTS.md

## Purpose

This subworkflow orchestrates the local RNA-seq processing path by wiring together index generation, FastQC, and quantification.

## Responsibilities

- accept typed read-pair and transcriptome inputs
- call `INDEX`, `FASTQC`, and `QUANT`
- emit sample-keyed FastQC and quantification channels for the top-level workflow

## Editing guidance

- Keep orchestration here and keep process implementation details in `modules/local/*`.
- Preserve emitted channel shapes unless `main.nf`, workflow outputs, and tests are updated together.
- Be careful with relative include paths from this nested location.
- If you add another module, document the new contract here and keep emit names explicit.

## Validation

Preferred checks from the repo root:

```bash
NXF_SYNTAX_PARSER=v2 nextflow lint .
nf-test test tests/default/main.nf.test
```
