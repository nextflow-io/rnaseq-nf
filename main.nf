#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */


/*
 * Default pipeline parameters. They can be overriden on the command line eg.
 * given `params.foo` specify on the run command line `--foo some_value`.
 */

params {
    reads: String = "${baseDir}/data/ggal/ggal_gut_{1,2}.fq"
    transcriptome: Path = file("${baseDir}/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa")
    outdir: String = 'results'
    multiqc: Path = file("${baseDir}/multiqc")
}


// import modules
include { RNASEQ } from './modules/rnaseq'
include { MULTIQC } from './modules/multiqc'

/* 
 * main script flow
 */
workflow {

    main:

    log.info """\
      R N A S E Q - N F   P I P E L I N E
      ===================================
      transcriptome: ${params.transcriptome}
      reads        : ${params.reads}
      outdir       : ${params.outdir}
    """.stripIndent()

    read_pairs_ch = channel.fromFilePairs(params.reads, checkIfExists: true, flat: true)

    (fastqc_ch, quant_ch) = RNASEQ(read_pairs_ch, params.transcriptome)

    multiqc_files_ch = fastqc_ch.mix(quant_ch).collect()

    MULTIQC(multiqc_files_ch, params.multiqc)

    onComplete:
        log.info(
            workflow.success
                ? "\nDone! Open the following report in your browser --> ${params.outdir}/multiqc_report.html\n"
                : "Oops .. something went wrong"
        )
}
