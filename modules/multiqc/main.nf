
process MULTIQC {
    conda 'bioconda::multiqc=1.25'

    input:
    inputs  : Bag<Path>
    config  : Path

    output:
    file('multiqc_report.html')

    script:
    """
    cp $config/* .
    echo "custom_logo: \$PWD/logo.png" >> multiqc_config.yaml
    multiqc -o multiqc_report.html .
    """
}
