---
purpose: Preserve the MultiQC aggregation contract.
applies_to: modules/local/multiqc/
entrypoint: main.nf
verification: NXF_VER=26.04.6 nf-test test --profile wave tests/default/main.nf.test
update_when: MultiQC inputs, assets, or report outputs change.
---

# AGENTS.md

## Purpose

This module aggregates FastQC and quantification outputs into a single `multiqc_report.html` report.

## Editing guidance

- The `config` input is expected to be a directory of MultiQC assets copied into the task workdir.
- Preserve the report filename `multiqc_report.html` unless the top-level workflow outputs are updated too.
- Keep this module aggregation-only; do not add upstream sample reshaping logic here.
- If MultiQC asset handling changes, validate against the real bundled example inputs.
