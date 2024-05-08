
process FASTQC {
    tag "FASTQC on $sample_id"
    conda 'fastqc=0.12.1'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "fastqc_${sample_id}_logs", emit: logs

    publish:
    logs >> 'fastqc'

    script:
    """
    fastqc.sh "$sample_id" "$reads"
    """
}
