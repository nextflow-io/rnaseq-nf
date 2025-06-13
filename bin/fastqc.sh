#!/usr/bin/env bash
id="$1"
reads="$2"

mkdir fastqc_${id}_logs
fastqc -o fastqc_${id}_logs -f fastq -q ${reads}
