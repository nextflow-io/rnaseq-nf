#!/usr/bin/env bash
reads="$1"

mkdir fastqc
fastqc -o fastqc -f fastq -q ${reads}
