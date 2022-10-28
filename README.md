# RNAseq-NF pipeline 

A basic pipeline for quantification of genomic features from short read data
implemented with Nextflow.

[![nextflow](https://img.shields.io/badge/nextflow-%E2%89%A50.24.0-brightgreen.svg)](http://nextflow.io)
[![Build Status](https://travis-ci.org/nextflow-io/rnaseq-nf.svg?branch=master)](https://travis-ci.org/nextflow-io/rnaseq-nf)

## Requirements 

* Unix-like operating system (Linux, macOS, etc)
* Java 8 

## Quickstart 

1. If you don't have it already install Docker in your computer. Read more [here](https://docs.docker.com/).

2. Install Nextflow (version 20.07.x or higher):
      
        curl -s https://get.nextflow.io | bash

3. Launch the pipeline execution: 

        ./nextflow run nextflow-io/rnaseq-nf -with-docker
        
4. When the execution completes open in your browser the report generated at the following path:

        results/multiqc_report.html 
	
You can see an example report at the following [link](http://multiqc.info/examples/rna-seq/multiqc_report.html).	
	
Note: the very first time you execute it, it will take a few minutes to download the pipeline 
from this GitHub repository and the associated Docker images needed to execute the pipeline.  

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

## Cluster support

RNASeq-NF execution relies on [Nextflow](http://www.nextflow.io) framework which provides an 
abstraction between the pipeline functional logic and the underlying processing system.

This allows the execution of the pipeline in a single computer or in a HPC cluster without modifying it.

Currently the following resource manager platforms are supported:

  + Univa Grid Engine (UGE)
  + Platform LSF
  + SLURM
  + PBS/Torque


By default the pipeline is parallelized by spawning multiple threads in the machine where the script is launched.

To submit the execution to a UGE cluster create a file named `nextflow.config` in the directory
where the pipeline is going to be executed with the following content:

    process {
      executor='uge'
      queue='<queue name>'
    }

To lean more about the avaible settings and the configuration file read the 
Nextflow [documentation](http://www.nextflow.io/docs/latest/config.html).


## Components 

RNASeq-NF uses the following software components and tools: 

* [Salmon](https://combine-lab.github.io/salmon/) 1.0.0
* [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) 0.11.5
* [Multiqc](https://multiqc.info) 1.5

