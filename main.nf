#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */

nextflow.preview.types = true


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
  reads: String = "${projectDir}/data/ggal/ggal_gut_{1,2}.fq"

  // The input transcriptome file
  transcriptome: Path = "${projectDir}/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa"

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
      transcriptome: ${params.transcriptome}
      reads        : ${params.reads}
      outdir       : ${workflow.outputDir}
    """.stripIndent()

  pairs = Channel.fromFilePairs(params.reads).map { (id, reads) ->
    [id: id, fastq_1: reads[0], fastq_2: reads[1]]
  }

  rnaseq = RNASEQ(pairs, params.transcriptome)

  multiqc_files = rnaseq.samples
    .scatter { s -> [ s.fastqc, s.quant ] }
    .collect()

  summary = MULTIQC(multiqc_files, params.multiqc)

  publish:
  index = rnaseq.index
  samples = rnaseq.samples
  summary = summary

  onComplete:
  log.info ( workflow.success
    ? "\nDone! Open the following report in your browser --> ${workflow.outputDir}/multiqc_report.html\n"
    : "Oops .. something went wrong" )
}

/*
 * Pipeline outputs. By default they will be saved to the 'results' directory.
 */
output {
  index: Path {
    path '.'
  }

  samples: Channel<Sample> {
    path { sample -> sample.id }
    index {
      path 'samples.json'
    }
  }

  summary: Path {
    path '.'
  }
}
