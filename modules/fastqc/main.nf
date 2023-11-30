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
        path { "fastqc_${sample.id}_logs" }
    },
    script=true
)
def FASTQC(Sample sample) {
    """
    fastqc.sh "$sample.id" "${sample.reads.join(' ')}"
    """
}
