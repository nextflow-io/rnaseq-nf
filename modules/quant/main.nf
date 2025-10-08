
process QUANT {
    tag "${id}"
    conda 'bioconda::salmon=1.10.3'

    input:
    tuple val(id), path(fastq_1), path(fastq_2)
    path index

    output:
    tuple val(id), path("quant_${id}")

    script:
    """
    salmon quant --threads ${task.cpus} --libType=U -i ${index} -1 ${fastq_1} -2 ${fastq_2} -o quant_${id}
    """
}
