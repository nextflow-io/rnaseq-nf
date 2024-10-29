
process FASTQC {
    tag "$sample_id"
    conda 'fastqc=0.12.1'

    input:
    tuple val(sample_id), path(fastq_1), path(fastq_2)

    output:
    tuple val(sample_id), path("fastqc_${sample_id}_logs"), emit: logs

    script:
    """
    fastqc.sh "$sample_id" "$fastq_1 $fastq_2"
    """
}
