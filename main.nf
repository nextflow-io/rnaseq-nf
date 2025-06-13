#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */

// enable v2 operators (required for static type checking)
nextflow.preview.operators = true

// enable static type checking
nextflow.preview.typeChecking = true

// import modules
include { RNASEQ } from './modules/rnaseq'
include { FastqPair ; Sample } from './modules/rnaseq'
include { MULTIQC } from './modules/multiqc'

/*
 * Pipeline parameters. They can be overridden on the command line, e.g.
 * `params.reads` can be specified as `--reads '...'`.
 */
params {
  // The input read-pair files
  reads: List<FastqPair>

  // The input transcriptome file
  transcriptome: Path

  // Directory containing multiqc configuration
  multiqc: Path = "${projectDir}/multiqc"
}

/* 
 * Entry workflow
 */
workflow {
  main:
  log.info """\
      R N A S E Q - N F   P I P E L I N E
      ===================================
      reads        : ${params.reads*.id.join(',')}
      transcriptome: ${params.transcriptome}
      outdir       : ${workflow.outputDir}
    """.stripIndent()

  (samples_ch, index) = RNASEQ( channel.fromList(params.reads), params.transcriptome )

  multiqc_files_ch = samples_ch
    .flatMap { sample -> [sample.fastqc, sample.quant] }
    .collect()

  multiqc_report = MULTIQC( multiqc_files_ch, params.multiqc )

  publish:
  index = index
  samples = samples_ch
  multiqc_report = multiqc_report

  onComplete:
  log.info(
    workflow.success
      ? "\nDone! Open the following report in your browser --> ${workflow.outputDir}/multiqc_report.html\n"
      : "Oops .. something went wrong"
  )
}

/*
 * Pipeline outputs. By default they will be saved to the 'results' directory.
 */
output {
  index: Path {
    path '.'
  }

  samples: Channel<Sample> {
    path { sample ->
      sample.fastqc >> "fastqc/${sample.id}"
      sample.quant >> "quant/${sample.id}"
    }
    index {
      path 'samples.csv'
      header true
    }
  }

  multiqc_report: Path {
    path '.'
  }
}
