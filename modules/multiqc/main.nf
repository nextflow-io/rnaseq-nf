
process MULTIQC {
    conda 'multiqc=1.17'

    input:
    path('*') 
    path(config) 

    output:
    path('multiqc_report.html'), emit: report

    publish:
    report >> 'multiqc'

    script:
    """
    cp $config/* .
    echo "custom_logo: \$PWD/logo.png" >> multiqc_config.yaml
    multiqc .
    """
}
