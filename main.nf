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

  inputs_ch = channel.fromPath(params.reads)
    .splitCsv()
    .map { id, fastq_1, fastq_2 ->
      tuple(id, file(fastq_1, checkIfExists: true), file(fastq_2, checkIfExists: true))
    }

  samples_ch = RNASEQ( params.transcriptome, inputs_ch )
    .map { id, fastqc, quant ->
      [id: id, fastqc: fastqc, quant: quant]
    }

  multiqc_files_ch = samples_ch
    .flatMap { sample -> [sample.fastqc, sample.quant] }
    .collect()
  multiqc_report = MULTIQC( multiqc_files_ch, params.multiqc )

  publish:
  samples = samples_ch
  multiqc_report = multiqc_report
}

output {
  samples {
    path { sample ->
      sample.fastqc >> "fastqc/${sample.id}"
      sample.quant >> "quant/${sample.id}"
    }
    index {
      path 'samples.csv'
      header true
    }
  }

  multiqc_report {
  }
}
