
process INDEX {
    tag "$transcriptome.simpleName"
    conda 'bioconda::salmon=1.6.0'
    
    input:
    path transcriptome 

    output:
    path 'index' 

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """
}
