---
purpose: Preserve the Salmon index module contract.
applies_to: modules/local/index/
entrypoint: main.nf
verification: NXF_VER=26.04.6 nf-test test --profile wave tests/default/main.nf.test
update_when: Index inputs, outputs, or flags change.
---

# AGENTS.md

## Purpose

This module builds a Salmon index from the transcriptome FASTA.

## Editing guidance

- Keep this module limited to index generation only.
- Preserve the output directory name `index` unless callers are updated.
- Changes to index flags can alter downstream quantification behavior, so treat them as semantic changes and validate the full pipeline.
- If adding optional parameters, prefer plumbing them through typed params or explicit workflow inputs rather than hidden assumptions.
