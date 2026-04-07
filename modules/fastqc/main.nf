params.outdir = 'results'

nextflow.preview.types = true

process FASTQC {
    tag "${id}"
    conda 'bioconda::fastqc=0.12.1'
    publishDir params.outdir, mode: 'copy'

    input:
    tuple(id: String, fastq_1: Path, fastq_2: Path)

    output:
    logs: Tuple<String, Path> = tuple(id, file("fastqc_${id}_logs"))

    script:
    """
    fastqc.sh "${id}" "${fastq_1} ${fastq_2}"
    """
}
