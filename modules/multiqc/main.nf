params.outdir = 'results'

process MULTIQC {
    conda 'bioconda::multiqc=1.27.1'

    input:
    path '*'
    path config

    output:
    path 'multiqc_report.html', emit: report

    script:
    """
    cp $config/* .
    echo "custom_logo: \$PWD/nextflow_logo.png" >> multiqc_config.yaml
    multiqc -n multiqc_report.html .
    """
}
