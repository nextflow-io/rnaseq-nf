
process FASTQC {
    tag "FASTQC on $id"
    conda 'bioconda::fastqc=0.12.1'

    input:
    id      : String
    fastq_1 : Path
    fastq_2 : Path

    script:
    """
    fastqc.sh $id "$fastq_1 $fastq_2"
    """

    output:
    file("fastqc_${id}_logs")
}
