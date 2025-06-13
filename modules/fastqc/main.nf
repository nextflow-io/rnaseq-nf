
process FASTQC {
    tag "$id"
    conda 'bioconda::fastqc=0.12.1'

    input:
    id      : String
    fastq_1 : Path
    fastq_2 : Path

    output:
    id      : String = id
    fastqc  : Path = file("fastqc_${id}_logs")

    script:
    """
    fastqc.sh "$id" "$fastq_1 $fastq_2"
    """
}
