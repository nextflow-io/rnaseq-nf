
@ProcessFn(
    directives={
        tag { pair.id }
        conda 'salmon=1.10.2'
    },
    inputs={
        path { index }
        path { pair.reads }
    },
    outputs={
        path { pair.id }
    },
    script=true
)
def QUANT(Path index, Sample pair) {
    """
    salmon quant --threads $task.cpus --libType=U -i $index -1 ${pair.reads[0]} -2 ${pair.reads[1]} -o $pair.id
    """
}
