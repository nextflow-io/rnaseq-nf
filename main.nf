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
params.multiqc = "$projectDir/multiqc"


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

  samples_ch = channel.fromPath(params.reads)
    .splitCsv()
    .map { id, fastq_1, fastq_2 ->
      tuple(id, file(fastq_1, checkIfExists: true), file(fastq_2, checkIfExists: true))
    }

  RNASEQ( params.transcriptome, samples_ch )
  MULTIQC( RNASEQ.out, params.multiqc )
}
