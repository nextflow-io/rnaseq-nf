# AGENTS.md

## Purpose

This module aggregates FastQC and quantification outputs into a single `multiqc_report.html` report.

## Contract

- input: `Set<Path> logs`, `Path config`
- output: `Path multiqc_report.html`

## Editing guidance

- The `config` input is expected to be a directory of MultiQC assets copied into the task workdir.
- Preserve the report filename `multiqc_report.html` unless the top-level workflow outputs are updated too.
- Keep this module aggregation-only; do not add upstream sample reshaping logic here.
- If MultiQC asset handling changes, validate against the real bundled example inputs.
