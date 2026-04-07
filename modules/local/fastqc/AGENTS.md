# AGENTS.md

## Purpose

This module wraps FastQC for one paired-end sample and emits the generated FastQC log directory keyed by sample ID.

## Editing guidance

- Keep the emitted sample ID stable; downstream workflow logic joins on it.
- Preserve the output directory naming convention `fastqc_${id}_logs` unless all consumers are updated.
- Prefer changes inside `resources/usr/bin/fastqc.sh` or process directives over ad hoc shell complexity here.
- Keep helper scripts module-scoped so they travel with this module when reused elsewhere.
