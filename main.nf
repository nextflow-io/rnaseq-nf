#!/usr/bin/env nextflow 

/* 
 * Copyright (c) 2013-2023, Seqera Labs.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. 
 * 
 * This Source Code Form is "Incompatible With Secondary Licenses", as
 * defined by the Mozilla Public License, v. 2.0.
 */

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 *
 * Authors:
 * - Paolo Di Tommaso <paolo.ditommaso@gmail.com>
 * - Emilio Palumbo <emiliopalumbo@gmail.com>
 * - Evan Floden <evanfloden@gmail.com>
 */

/* 
 * enables modules 
 */
nextflow.enable.dsl = 2

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
    """

  read_pairs_ch = channel.fromFilePairs( params.reads, checkIfExists: true, flat: true )
  RNASEQ( params.transcriptome, read_pairs_ch )

  samples_ch = RNASEQ.out.quant
    | join(RNASEQ.out.fastqc)

  multiqc_ch = RNASEQ.out.quant
    | concat(RNASEQ.out.fastqc)
    | map { _id, file -> file }
    | collect
  MULTIQC( multiqc_ch, params.multiqc )

  publish:
  samples_ch >> 'samples'
  MULTIQC.out >> 'multiqc'
}

output {
  samples {
    path { id, _quant, _fastqc -> "${workflow.outputDir}/${id}" }
    index {
      path 'index.json'
      mapper { id, quant, fastqc ->
        [id: id, quant: quant, fastqc: fastqc]
      }
    }
  }
}
