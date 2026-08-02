---
purpose: Guide small, verifiable agent edits to rnaseq-nf.
applies_to: Entire repository.
entrypoint: main.nf
verification: NXF_VER=26.04.6 nf-test test --profile wave tests/default/main.nf.test
update_when: Workflow structure or validation commands change.
---

# Agent guidance

Keep this repository a minimal Nextflow RNA-seq reference, not a framework.

## Conventions

- Preserve typed records across workflow and process boundaries.
- Keep processes under `modules/local/` and orchestration under `subworkflows/local/`.
- Update both JSON schemas when the samplesheet contract changes.
- Put executor and cloud settings in external config overlays.
- Make one logical, green commit at a time.

## Validation

From the repository root:

```console
NXF_VER=26.04.6 nextflow lint .
NXF_VER=26.04.6 nf-test test --profile wave tests/default/main.nf.test
```
