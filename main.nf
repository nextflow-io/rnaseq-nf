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

  read_pairs_ch = channel.fromFilePairs( params.reads, checkIfExists: true, flat: true )
  RNASEQ( params.transcriptome, read_pairs_ch )

  samples_ch = RNASEQ.out.fastqc
    .join(RNASEQ.out.quant)
    .map { id, fastqc, quant ->
      [id: id, fastqc: fastqc, quant: quant]
    }

  multiqc_files_ch = samples_ch
    .flatMap { sample -> [sample.fastqc, sample.quant] }
    .collect()
  MULTIQC( multiqc_files_ch, params.multiqc )

  publish:
  samples = samples_ch
  multiqc_report = MULTIQC.out
}

output {
  samples {
    path { sample ->
      sample.fastqc >> "fastqc/${sample.id}"
      sample.quant >> "quant/${sample.id}"
    }
    index {
      path 'samples.json'
    }
  }

  multiqc_report {
  }
}
