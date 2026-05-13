
nextflow.enable.types = true

process QUANT {
    tag id
    conda 'bioconda::salmon=1.10.3'

    input:
    record(
        id: String,
        fastq_1: Path,
        fastq_2: Path
    )
    index: Path

    output:
    record(
        id: id,
        quant: file("quant_${id}")
    )

    script:
    """
    salmon quant \
        --threads ${task.cpus} \
        --libType=U \
        -i ${index} \
        -1 ${fastq_1} \
        -2 ${fastq_2} \
        -o quant_${id}
    """
}
