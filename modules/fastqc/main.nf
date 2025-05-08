
process FASTQC {
    tag "$id"
    conda 'bioconda::fastqc=0.12.1'

    input:
    tuple val(id), path(fastq_1), path(fastq_2)

    output:
    tuple val(id), path('fastqc')

    script:
    """
    fastqc.sh "$fastq_1 $fastq_2"
    """
}
