---
purpose: Preserve the RNA-seq orchestration contract.
applies_to: subworkflows/local/rnaseq/
entrypoint: main.nf
verification: NXF_VER=26.04.6 nf-test test --profile wave tests/default/main.nf.test
update_when: Subworkflow inputs, outputs, or module wiring change.
---

# AGENTS.md

## Purpose

This subworkflow orchestrates the local RNA-seq processing path by wiring together index generation, FastQC, and quantification.

## Editing guidance

- Keep orchestration here and keep process implementation details in `modules/local/*`.
- Preserve emitted channel shapes unless `main.nf`, workflow outputs, and tests are updated together.
- Be careful with relative include paths from this nested location.
- If you add another module, document the new contract here and keep emit names explicit.
