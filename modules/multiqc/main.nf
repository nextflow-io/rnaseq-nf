params.outdir = 'results'

process MULTIQC {
    conda 'multiqc=1.17'
    publishDir params.outdir, mode:'copy'

    input:
    path('*') 
    path(config) 

    output:
    path('multiqc_report.html'), emit: report

    script:
    """
    cp $config/* .
    echo "custom_logo: \$PWD/logo.png" >> multiqc_config.yaml
    multiqc .
    """
}
