
@ProcessFn(
    directives={
        tag { transcriptome.simpleName }
        conda 'salmon=1.10.2'
    },
    inputs={
        path { transcriptome }
    },
    outputs={
        path '$file0', 'index'
        emit { path('$file0') }
    },
    script=true
)
def INDEX(Path transcriptome) {
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """
}
