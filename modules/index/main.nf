
process INDEX {
    tag "$transcriptome.simpleName"
    conda 'bioconda::salmon=1.10.3'
    
    input:
    path transcriptome 

    output:
    path 'index' 

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """
}
