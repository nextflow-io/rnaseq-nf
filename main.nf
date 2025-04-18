#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */

nextflow.preview.output = true

/*
 * Default pipeline parameters. They can be overriden on the command line eg.
 * given `params.foo` specify on the run command line `--foo some_value`.
 */
params.reads = "$baseDir/data/ggal/ggal_gut_{1,2}.fq"
params.transcriptome = "$baseDir/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa"
params.outdir = "results"
params.multiqc = "$baseDir/multiqc"

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

  read_pairs_ch = channel.fromFilePairs( params.reads, checkIfExists: true, flat: true )
  RNASEQ( params.transcriptome, read_pairs_ch )

  samples_ch = RNASEQ.out.quant
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
  samples = samples_ch
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
