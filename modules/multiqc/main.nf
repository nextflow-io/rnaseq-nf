params.outdir = 'results'

process MULTIQC {
    conda 'bioconda::multiqc=1.17'
    publishDir params.outdir, mode:'copy'

    input:
    path '*'
    path 'config'

    output:
    path 'multiqc_report.html', emit: report

    script:
    """
    cp $config/* .
    echo "custom_logo: \$PWD/logo.png" >> multiqc_config.yaml
    multiqc -o multiqc_report.html .
    """
}
