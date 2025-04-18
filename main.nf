#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */

nextflow.preview.output = true

/*
 * Default pipeline parameters. They can be overriden on the command line eg.
 * given `params.reads` specify on the run command line `--reads some_value`.
 */

params.reads = null
params.transcriptome = null
params.outdir = "results"
params.multiqc = "$projectDir/multiqc"

/*
 * import modules
 */
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

  inputs_ch = channel.fromPath(params.reads)
    .splitCsv()
    .map { id, fastq_1, fastq_2 ->
      tuple(id, file(fastq_1, checkIfExists: true), file(fastq_2, checkIfExists: true))
    }

  RNASEQ( params.transcriptome, inputs_ch )

  rnaseq_ch = RNASEQ.out.quant
    .join(RNASEQ.out.fastqc)
    .map { id, quant, fastqc ->
      [id: id, quant: quant, fastqc: fastqc]
    }

  multiqc_ch = RNASEQ.out.quant
    .concat(RNASEQ.out.fastqc)
    .map { _id, file -> file }
    .collect()
  MULTIQC( multiqc_ch, params.multiqc )

  publish:
  samples = rnaseq_ch
  summary = MULTIQC.out
}

output {
  samples {
    path { sample ->
      sample.quant >> "${sample.id}/"
      sample.fastqc >> "${sample.id}/"
    }
    index {
      path 'samples.json'
    }
  }

  summary {
  }
}
