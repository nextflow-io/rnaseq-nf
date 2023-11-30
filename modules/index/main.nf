
@ProcessFn(
    directives={
        tag { transcriptome.simpleName }
        conda 'salmon=1.10.2'
    },
    inputs={
        path { transcriptome } 
    },
    outputs={
        path 'index' 
    },
    script=true
)
def INDEX(Path transcriptome) {
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """
}
