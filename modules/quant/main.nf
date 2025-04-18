
process QUANT {
    tag "$sample_id"
    conda 'bioconda::salmon=1.10.3'

    input:
    path index
    tuple val(sample_id), path(fastq_1), path(fastq_2)

    output:
    tuple val(sample_id), path('quant')

    script:
    """
    salmon quant --threads $task.cpus --libType=U -i $index -1 ${fastq_1} -2 ${fastq_2} -o quant
    """
}
