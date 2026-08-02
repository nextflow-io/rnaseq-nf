---
purpose: Preserve the FastQC module contract.
applies_to: modules/local/fastqc/
entrypoint: main.nf
verification: NXF_VER=26.04.6 nf-test test --profile wave tests/default/main.nf.test
update_when: FastQC inputs, outputs, or helper layout change.
---

# AGENTS.md

## Purpose

This module wraps FastQC for one paired-end sample and emits the generated FastQC log directory keyed by sample ID.

## Editing guidance

- Keep the emitted sample ID stable; downstream workflow logic joins on it.
- Preserve the output directory naming convention `fastqc_${id}_logs` unless all consumers are updated.
- Prefer changes inside `resources/usr/bin/fastqc.sh` or process directives over ad hoc shell complexity here.
- Keep helper scripts module-scoped so they travel with this module when reused elsewhere.
