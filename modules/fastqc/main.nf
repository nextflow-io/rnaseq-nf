
process FASTQC {
    tag "FASTQC on $sample_id"
    conda 'bioconda::fastqc=0.12.1'

    input:
    sample_id   : String
    fastq_1     : Path
    fastq_2     : Path

    script:
    """
    fastqc.sh $sample_id "$fastq_1 $fastq_2"
    """

    output:
    file("fastqc_${sample_id}_logs")
}
