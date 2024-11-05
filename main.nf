#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */

nextflow.preview.types = true

/*
 * Default pipeline parameters. They can be overridden on the command line, e.g.
 * `params.reads` can be specified on the command line as `--reads some_value`.
 */

params.reads = "${projectDir}/data/ggal/ggal_gut_{1,2}.fq"
params.transcriptome = "${projectDir}/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa"
params.multiqc = "${projectDir}/multiqc"


// import modules
include { RNASEQ } from './modules/rnaseq'
include { FastqPair ; Sample } from './modules/rnaseq'
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
    outdir       : ${workflow.outputDir}
    """.stripIndent()

  let (index, samples) = params.reads
    |> Channel.fromFilePairs( checkIfExists: true )         // Channel<(String,List<Path>)>
    |> map { (id, reads) ->
      new FastqPair(id, reads[0], reads[1])
    }                                                       // Channel<FastqPair>
    |> RNASEQ( file(params.transcriptome) )                 // NamedTuple(index: Path, samples: Channel<Sample>)

  let summary = samples
    |> flatMap { s -> [ s.fastqc, s.quant ] }               // Channel<Path>
    |> collect                                              // Bag<Path> (future)
    |> MULTIQC( file(params.multiqc) )                      // Path (future)

  workflow.onComplete {
    log.info ( workflow.success
      ? "\nDone! Open the following report in your browser --> ${workflow.outputDir}/multiqc_report.html\n"
      : "Oops .. something went wrong" )
  }

  publish:
  index >> 'index'
  samples >> 'samples'
  summary >> 'summary'
}

output {
  index: Path {
    path '.'
  }

  samples: Sample {
    path { sample -> sample.id }
    index {
      path 'samples.json'
    }
  }

  summary: Path {
    path '.'
  }
}
