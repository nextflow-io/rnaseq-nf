params.outdir = 'results'

process FASTQC {
    tag "FASTQC on $sample_id"
    conda 'bioconda::fastqc=0.11.9'
    publishDir params.outdir, mode:'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "fastqc_${sample_id}_logs" 

    script:
    """
    fastqc.sh "$sample_id" "$reads"
    """
}
