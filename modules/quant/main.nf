
process QUANT {
    tag "$sample_id"
    conda 'bioconda::salmon=1.10.3'

    input:
    index       : Path
    sample_id   : String
    fastq_1     : Path
    fastq_2     : Path

    script:
    """
    salmon quant --threads $task.cpus --libType=U -i $index -1 ${fastq_1} -2 ${fastq_2} -o quant_${sample_id}
    """

    output:
    file("quant_${sample_id}") 
}
