# AGENTS.md

## Purpose

This module wraps FastQC for one paired-end sample and emits the generated FastQC log directory keyed by sample ID.

## Contract

- input: `Tuple<String, Path, Path>` as `(id, fastq_1, fastq_2)`
- output: `Tuple<String, Path>` as `(id, fastqc_log_dir)`

## Editing guidance

- Keep the emitted sample ID stable; downstream workflow logic joins on it.
- Preserve the output directory naming convention `fastqc_${id}_logs` unless all consumers are updated.
- Prefer changes inside `bin/fastqc.sh` or process directives over ad hoc shell complexity here.
- If you add extra outputs, make them explicit and typed.
