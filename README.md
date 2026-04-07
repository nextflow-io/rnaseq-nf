# RNAseq-NF pipeline 

A basic pipeline for quantification of genomic features from short read data
implemented with Nextflow.

[![nextflow](https://img.shields.io/badge/nextflow-%E2%89%A523.04.0-brightgreen.svg)](http://nextflow.io)


## Requirements 

* Unix-like operating system (Linux, macOS, etc)
* Java 11 

## Quickstart 

1. If you don't have it already install Docker in your computer. This example uses Docker as the local container runtime for Wave. Read more [here](https://docs.docker.com/).

2. Install Nextflow (version 23.10.0 or later):
      
        curl -s https://get.nextflow.io | bash

3. Launch the pipeline execution with Wave-managed containers: 

        ./nextflow run nextflow-io/rnaseq-nf
        
4. When the execution completes open in your browser the report generated at the following path:

        results/multiqc_report.html 
	
You can see an example report at the following [link](http://multiqc.info/examples/rna-seq/multiqc_report.html).	
	
Note: the very first time you execute it, it will take a few minutes to download the pipeline 
from this GitHub repository and let Wave provision the containers needed to execute the workflow.  

## Profiles

This example intentionally keeps only a small set of profiles:

- `all-reads` — convenience profile that runs the full bundled example dataset

Examples:

```bash
./nextflow run .
./nextflow run . -profile all-reads
```

## Pipeline flowchart

Here is a visual representation of the design of RNASeq-NF pipeline, generated using the [visualization functionality](https://www.nextflow.io/docs/latest/tracing.html#dag-visualisation) of Nextflow.

```mermaid
%%{init: { 'theme': 'forest' } }%%
flowchart TD
    p0((Channel.fromFilePairs))
    p1(( ))
    p2[RNASEQ:INDEX]
    p3[RNASEQ:FASTQC]
    p4[RNASEQ:QUANT]
    p5([concat])
    p6([collect])
    p7(( ))
    p8[MULTIQC]
    p9(( ))
    p0 -->|read_pairs_ch| p3
    p1 -->|transcriptome| p2
    p2 --> p4
    p3 --> p5
    p0 -->|read_pairs_ch| p4
    p4 -->|pair_id| p5
    p5 --> p6
    p6 -->|$out0| p8
    p7 -->|config| p8
    p8 --> p9
```

## Execution notes

This repository is now tuned as a small local-first example for agentic development work.
If you want to run it on HPC or cloud executors, add a separate config overlay rather than
re-expanding the built-in profile list.

## Data lineage

Data lineage is enabled in `nextflow.config` via `lineage.enabled = true`, so recent Nextflow
versions will record workflow runs, task executions, and published outputs in a local `.lineage/`
store by default.

Useful commands after a run:

```bash
nextflow lineage list
nextflow lineage render <LID>
```

This feature is experimental in Nextflow and was introduced in Nextflow 25.04, so use a compatible recent release when exploring lineage metadata.

## Components 

RNASeq-NF uses the following software components and tools: 

* [Salmon](https://combine-lab.github.io/salmon/)
* [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* [MultiQC](https://multiqc.info)

