params.outdir = 'results'

process FASTQC {
    tag "${id}"
    conda 'bioconda::fastqc=0.12.1'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple val(id), path(reads)

    output:
    path "fastqc_${id}_logs", emit: logs

    script:
    """
    fastqc.sh "${id}" "${reads}"
    """
}
