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
  reads: String {
    description 'The input read-pair files'
    faIcon 'fas fa-folder-open'
    defaultValue "${projectDir}/data/ggal/ggal_gut_{1,2}.fq"
  }

  transcriptome: String {
    description 'The input transcriptome file'
    faIcon 'fas fa-folder-open'
    defaultValue "${projectDir}/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa"
  }

  multiqc: String {
    description 'Directory containing multiqc configuration'
    faIcon 'fas fa-folder-open'
    defaultValue "${projectDir}/multiqc"
  }
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

  def (index, samples) = params.reads
    |> Channel.fromFilePairs( checkIfExists: true )         // Channel<(String,List<Path>)>
    |> map { (id, reads) ->
      new FastqPair(id, reads[0], reads[1])
    }                                                       // Channel<FastqPair>
    |> RNASEQ( file(params.transcriptome) )                 // NamedTuple(index: Path, samples: Channel<Sample>)

  def summary = samples
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

/*
 * Pipeline outputs. By default they will be saved to the 'results' directory.
 */
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
