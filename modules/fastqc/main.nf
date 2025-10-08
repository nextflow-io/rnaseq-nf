
nextflow.preview.types = true

process FASTQC {
    tag "${id}"
    conda 'bioconda::fastqc=0.12.1'

    input:
    (id, fastq_1, fastq_2): Tuple<String, Path, Path>

    output:
    tuple(id, file("fastqc_${id}_logs"))

    script:
    """
    fastqc.sh "${id}" "${fastq_1} ${fastq_2}"
    """
}
