# RNAseq-NF pipeline demo for kubernetes

A basic pipeline for quantification of genomic features from short read data
implemented with Nextflow.

This branch (k8s-demo) contains specific instructutions for running the pipeline with the kubernetes executor.

[![nextflow](https://img.shields.io/badge/nextflow-%E2%89%A50.24.0-brightgreen.svg)](http://nextflow.io)
[![CircleCI status](https://circleci.com/gh/nextflow-io/rnaseq-nf.png?style=shield)](https://circleci.com/gh/nextflow-io/rnaseq-nf/tree/master)

## Background

The branch contains a the basic instructions for running the RNAseq pipeline with Nextflow using the kubernetes executor. 

You can read the documentation about the kubernetes executor [here](https://www.nextflow.io/docs/latest/executor.html#kubernetes).

## Requirements

* Unix-like operating system (Linux, macOS, etc)
* Java 7/8
* Docker
* Kubernetes command line client (kubectl)

## Quickstart 

If you have the requirements above, you can simply: 

1. Install Nextflow (version 0.24.x or higher):

        curl -s https://get.nextflow.io | bash

2. Pull the docker image:

        docker pull nextflow/rnaseq-nf

        
3. Create a file named `nextflow.config` with the following content:

        process.container = 'nextflow/rnaseq-nf:latest'
        process.executor = 'k8s'

4. Run the pipeline on your kubernetes cluster:

        ./nextflow run nextflow-io/rnaseq-nf


## Installation

If you do not have your own kubernetes cluster setup, but still want to try kubernetes, you can use [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube/) to set up a one-node kubernetes cluster locally and run the workflow using the kubernetes executer.

1. Install Vagrant

See instructions for [installing Vagrant](Install Vagrant in your Mac
https://www.vagrantup.com/docs/installation/)

2. Create a Ubuntu Xenial box

    Create an empty dir and change into 
       
       vagrant init ubuntu/xenial64
	   
    Make sure the VM has 8 GB ram.

        vagrant up 
        vagrant ssh

3. Install Java

        sudo apt install openjdk-8-jre-headless

4. Install Docker

    Follow [this](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04) tutorial.

5. Install Minikube & start it

        curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
        CHANGE_MINIKUBE_NONE_USER=true sudo minikube start --vm-driver none
        sudo chown -R $USER $HOME/.kube
        sudo chgrp -R $USER $HOME/.kube
        sudo chown -R $USER $HOME/.minikube
        sudo chgrp -R $USER $HOME/.minikube 
        
6. Install Kubernetes client

        curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin

7. Confirm kubernest is running

        $ kubectl get pods --all-namespaces
        NAMESPACE     NAME                               READY     STATUS    RESTARTS   AGE
        kube-system   kube-addon-manager-ubuntu-xenial   1/1       Running   2          30m
        kube-system   kube-dns-6fc954457d-t7tdz          3/3       Running   3          30m
        kube-system   kubernetes-dashboard-rv96f         1/1       Running   1          30m

8. Download the rnaseq-nf docker image:

        docker pull nextflow/rnaseq-nf


9. Create a file named `nextflow.config` with the following content:

        process.container = 'nextflow/rnaseq-nf:latest'
        process.executor = 'k8s'

10. Run the pipeline on your local kubernetes cluster:

        ./nextflow run nextflow-io/rnaseq-nf
 
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

* [Salmon](https://combine-lab.github.io/salmon/) 0.8.2
* [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) 0.11.5
* [Multiqc](https://multiqc.info) 1.0

