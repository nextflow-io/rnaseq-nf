#!/usr/bin/env nextflow

/*
 * Pipeline parameters
 */

// Input data
params.reads = "${workflow.projectDir}/data/ggal/ggal_gut_{1,2}.fq"

// Reference file
params.transcriptome = "${workflow.projectDir}/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa"

// Output directory
params.outdir = "results"

/*
 * Index reference transcriptome file
 */
process INDEX {
    tag "$transcriptome.simpleName"
    container "community.wave.seqera.io/library/salmon:1.10.3--482593b6cd04c9b7"
    conda "bioconda::salmon=1.10.3"

    input:
    path transcriptome

    output:
    path 'index'

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """
}

/*
 * Generate FastQC reports
 */
process FASTQC {
    tag "FASTQC on $sample_id"
    publishDir params.outdir, mode:'copy'
    container "community.wave.seqera.io/library/fastqc:0.12.1--5cfd0f3cb6760c42"
    conda "bioconda::fastqc:0.12.1"

    input:
    tuple val(sample_id), path(reads)

    output:
    path "fastqc_${sample_id}_logs"

    script:
    """
    mkdir fastqc_${sample_id}_logs
    fastqc -o fastqc_${sample_id}_logs -f fastq -q ${reads}
    """
}

/*
 * Quantify reads
 */
process QUANT {
    tag "$pair_id"
    publishDir params.outdir, mode:'copy'
    container "community.wave.seqera.io/library/salmon:1.10.3--482593b6cd04c9b7"
    conda "bioconda::salmon=1.10.3"

    input:
    path index
    tuple val(pair_id), path(reads)

    output:
    path pair_id

    script:
    """
    salmon quant --threads $task.cpus --libType=U -i $index -1 ${reads[0]} -2 ${reads[1]} -o $pair_id
    """
}

/*
 * Generate MultiQC report
 */
process MULTIQC {
  publishDir params.outdir, mode:'copy'
    container "community.wave.seqera.io/library/multiqc:1.24.1--789bc3917c8666da"
    conda "bioconda::multiqc:1.24.1"

    input:
    path '*'

    output:
    path 'multiqc_report.html'

    script:
    """
    multiqc .
    """
}

workflow {

    // Paired reference data
    read_pairs_ch = channel.fromFilePairs( params.reads, checkIfExists: true )

    // Index reference transcriptome file
    INDEX(params.transcriptome)

    // Generate FastQC reports
    FASTQC(read_pairs_ch)

    // Quantify reads
    QUANT(INDEX.out, read_pairs_ch)

    // Generate MultiQC report
    MULTIQC(QUANT.out.mix(FASTQC.out).collect())
}