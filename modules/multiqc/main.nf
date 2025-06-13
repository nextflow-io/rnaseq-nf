
process MULTIQC {
    conda 'bioconda::multiqc=1.27.1'

    input:
    inputs  : Bag<Path>
    config  : Path

    output:
    file('multiqc_report.html')

    script:
    """
    cp $config/* .
    echo "custom_logo: \$PWD/nextflow_logo.png" >> multiqc_config.yaml
    multiqc -n multiqc_report.html .
    """
}
