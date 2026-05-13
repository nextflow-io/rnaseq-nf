#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */

/*
 * Default pipeline parameters. They can be overriden on the command line eg.
 * given `params.reads` specify on the run command line `--reads some_value`.
 */

params.reads = null
params.transcriptome = null
params.outdir = "results"
params.multiqc = "${projectDir}/multiqc"


// import modules
include { RNASEQ } from './modules/rnaseq'
include { MULTIQC } from './modules/multiqc'

/* 
 * main script flow
 */
workflow {

    log.info """\
      R N A S E Q - N F   P I P E L I N E
      ===================================
      transcriptome: ${params.transcriptome}
      reads        : ${params.reads}
      outdir       : ${params.outdir}
    """.stripIndent()

    // Create a channel of paired-end reads from the glob in `params.reads`.
    // `checkIfExists: true` fails fast if no files match; `flat: true` flattens
    // the pair into the tuple so each emission is `[sample_id, read1, read2]`,
    // e.g. ['ggal_gut', ggal_gut_1.fq, ggal_gut_2.fq].
    read_pairs_ch = channel.fromFilePairs(params.reads, checkIfExists: true, flat: true)

    // Run the RNASEQ sub-workflow over each read pair against the transcriptome.
    // It emits two channels which we destructure here:
    //   - fastqc_ch: per-sample FastQC report directories
    //   - quant_ch : per-sample Salmon quantification directories
    (fastqc_ch, quant_ch) = RNASEQ(read_pairs_ch, params.transcriptome)

    // Mix FastQC and Salmon outputs into a single stream (`mix`) and collect
    // every emission into a list (`collect`) so that MultiQC sees all results at
    // once, e.g. [fastqc/ggal_gut, quant/ggal_gut, fastqc/ggal_liver, ...].
    multiqc_files_ch = fastqc_ch.mix(quant_ch).collect()

    // Run MultiQC on the collected result files using the config in `params.multiqc`
    // to produce a single consolidated HTML report (`multiqc_report.html`).
    MULTIQC(multiqc_files_ch, params.multiqc)

    workflow.onComplete = {
        log.info(
            workflow.success
                ? "\nDone! Open the following report in your browser --> ${params.outdir}/multiqc_report.html\n"
                : "Oops .. something went wrong"
        )
    }
}
