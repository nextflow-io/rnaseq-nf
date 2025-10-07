
process QUANT {
    tag "${id}"
    conda 'bioconda::salmon=1.10.3'

    input:
    path index
    tuple val(id), path(reads)

    output:
    path id

    script:
    """
    salmon quant --threads ${task.cpus} --libType=U -i ${index} -1 ${reads[0]} -2 ${reads[1]} -o ${id}
    """
}
