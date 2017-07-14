# RNAseq-NF pipeline 

A basic pipeline for quantification of genomic features from short read data
implemented with Nextflow.

[![nextflow](https://img.shields.io/badge/nextflow-%E2%89%A50.24.0-brightgreen.svg)](http://nextflow.io)
![CircleCI status](https://circleci.com/gh/nextflow-io/rnatoy.png?style=shield)

## Requirements 

* Unix-like operating system (Linux, macOS, etc)
* Java 7/8 

## Quickstart 

1) If you don't have it already install Docker in your computer. Read more [here](https://docs.docker.com/).

2) Install Nextflow (version 0.24.x or higher)

    `curl -fsSL get.nextflow.io | bash`

3) Launch the pipeline execution: 

    `./nextflow run nextflow-io/rnatoy -with-docker` 
        
When the execution completes check the transcript files in the current directory (`*.gtf`). 

Note: the very first time you execute it, it will a few seconds to download the associated 
Docker image required to execute the pipeline.  

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

To submit the execution to a UGE cluster create a file named `nextflow.config`, in the directory
where the pipeline is going to be executed with the following content:

    process {
      executor='uge'
      queue='<queue name>'
    }

To lean more about the avaible settings and the configuration file read the 
[Nextflow documentation](http://www.nextflow.io/docs/latest/config.html).


## Components 

RNASeq-NF uses the following software components and tools: 

* [Salmon](https://combine-lab.github.io/salmon/)
* [Fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
* [Multiqc](https://multiqc.info)

