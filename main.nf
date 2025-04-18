#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */

nextflow.preview.output = true
nextflow.preview.params = true

/*
 * import modules
 */
include { RNASEQ } from './modules/rnaseq'
include { MULTIQC } from './modules/multiqc'

/*
 * Pipeline parameters can be overridden on the command line,
 * e.g. `--reads myreads.csv --transcriptome myref.fa`.
 */
params {
  /**
   * CSV file of FASTQ pairs to analyze.
   */
  reads

  /**
   * FASTA file for the reference transcriptome.
   */
  transcriptome

  /**
   * Directory containing the configuration for MultiQC.
   */
  multiqc = "$projectDir/multiqc"
}

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
      outdir       : ${workflow.outputDir}
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
