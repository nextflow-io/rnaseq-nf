# AGENTS.md

## Purpose

This module builds a Salmon index from the transcriptome FASTA.

## Editing guidance

- Keep this module limited to index generation only.
- Preserve the output directory name `index` unless callers are updated.
- Changes to index flags can alter downstream quantification behavior, so treat them as semantic changes and validate the full pipeline.
- If adding optional parameters, prefer plumbing them through typed params or explicit workflow inputs rather than hidden assumptions.
