nextflow.preview.types = true

process FASTQC {
    tag "${id}"
    conda 'bioconda::fastqc=0.12.1'

    input:
    record(
        id: String,
        fastq_1: Path,
        fastq_2: Path?
    )

    output:
    record(
        id: id,
        fastqc: file("fastqc_${id}_logs")
    )

    script:
    def reads = fastq_2 ? "${fastq_1} ${fastq_2}" : "${fastq_1}"
    """
    fastqc.sh "${id}" "${reads}"
    """
}
