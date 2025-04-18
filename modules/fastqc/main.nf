
process FASTQC {
    tag "$sample_id"
    conda 'bioconda::fastqc=0.12.1'

    input:
    tuple val(sample_id), path(fastq_1), path(fastq_2)

    output:
    tuple val(sample_id), path('fastqc')

    script:
    """
    fastqc.sh "$fastq_1 $fastq_2"
    """
}
