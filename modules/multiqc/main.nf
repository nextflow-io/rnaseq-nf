params.outdir = 'results'

@ProcessFn(
    directives={
        conda 'multiqc=1.17'
        publishDir params.outdir, mode:'copy'
    },
    inputs={
        path { files }, stageAs: '*'
        path { config }
    },
    outputs={
        path('multiqc_report.html')
    },
    script=true
)
def MULTIQC(List<Path> files, Path config) {
    """
    cp $config/* .
    echo "custom_logo: \$PWD/logo.png" >> multiqc_config.yaml
    multiqc .
    """
}
