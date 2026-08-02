---
purpose: Explain the minimal rnaseq-nf example and how to run it.
applies_to: Pipeline users and contributors.
entrypoint: main.nf
verification: NXF_VER=26.04.6 nf-test test tests/default/main.nf.test
update_when: Inputs, outputs, requirements, or run commands change.
---

# rnaseq-nf pipeline

A basic pipeline for quantification of genomic features from short-read data, implemented with [Nextflow](http://www.nextflow.io).

[![nextflow](https://img.shields.io/badge/nextflow-%E2%89%A526.04.0-brightgreen.svg)](http://nextflow.io)

## Requirements

* Unix-like operating system (Linux, macOS, etc)
* Java 17

## Quickstart

1. Install [Docker](https://docs.docker.com/) if you don't have it already.

2. Install Nextflow (version 26.04 or later):

   ```bash
   curl -s https://get.nextflow.io | bash
   ```

3. Launch the pipeline:

   ```bash
   ./nextflow run nextflow-io/rnaseq-nf
   ```

4. When the run completes, open the following report in your browser:

   ```bash
   results/multiqc_report.html
   ```

You can view an [example report](https://seqera.io/examples/rna-seq/multiqc_report) in the MultiQC documentation.

> [!NOTE]
>
> When you run the pipeline for the first time, it will take a moment to download the pipeline and let Wave provision its containers.

## Samplesheet input

`--reads` accepts a CSV with three columns:

```csv
sample,fastq_1,fastq_2
ggal_gut,https://example.org/gut_1.fq,https://example.org/gut_2.fq
```

The bundled default is `data/gut.csv`. Run all four bundled samples with:

```console
nextflow run . -profile all-reads
```

## Execution

The example runs locally with Docker and Wave. Supply executor or cloud settings in an external [configuration file](https://docs.seqera.io/nextflow/config) instead of adding built-in profiles.

## Development

Run the end-to-end smoke test from the repository root:

```console
NXF_VER=26.04.6 nf-test test tests/default/main.nf.test
```

## Software dependencies

The rnaseq-nf pipeline uses the following software tools:

* [Salmon](https://combine-lab.github.io/salmon/)
* [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* [MultiQC](https://multiqc.info)
