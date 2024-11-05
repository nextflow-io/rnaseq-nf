
process INDEX {
    tag "$transcriptome.simpleName"
    conda 'bioconda::salmon=1.10.3'

    input:
    transcriptome   : Path

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """

    output:
    file('index')
}
