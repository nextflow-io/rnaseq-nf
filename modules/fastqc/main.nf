params.outdir = 'results'

@ProcessFn(
    directives={
        tag { "FASTQC on $sample.id" }
        conda 'fastqc=0.12.1'
        publishDir params.outdir, mode:'copy'
    },
    inputs={
        path { sample.reads }
    },
    outputs={
        path '$file0', { "fastqc_${sample.id}_logs" }
        emit { path('$file0') }
    },
    script=true
)
def FASTQC(Sample sample) {
    """
    fastqc.sh "$sample.id" "$sample.reads"
    """
}
