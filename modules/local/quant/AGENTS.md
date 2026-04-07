# AGENTS.md

## Purpose

This module runs Salmon quantification for one paired-end sample against a prebuilt index.

## Contract

- input: `Tuple<String, Path, Path>` plus `Path index`
- output: `Tuple<String, Path>` as `(id, quant_dir)`

## Editing guidance

- Keep the emitted sample ID stable; downstream joins depend on it.
- Preserve the output directory naming convention `quant_${id}` unless callers and published workflow outputs are updated.
- Quantification flags are behavior-changing; validate the end-to-end pipeline after any option changes.
- Keep this file focused on the process wrapper, not orchestration.
