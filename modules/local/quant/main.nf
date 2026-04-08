nextflow.preview.types = true

process QUANT {
    tag "${id}"
    conda 'bioconda::salmon=1.10.3'

    input:
    record(
        id: String,
        fastq_1: Path,
        fastq_2: Path?
    )
    index: Path

    output:
    record(
        id: id,
        quant: file("quant_${id}")
    )

    script:
    def readArgs = fastq_2 ? "-1 ${fastq_1} -2 ${fastq_2}" : "-r ${fastq_1}"
    """
    salmon quant --threads ${task.cpus} --libType=U -i ${index} ${readArgs} -o quant_${id}
    """
}
