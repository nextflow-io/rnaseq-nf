#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */

nextflow.preview.types = true

/*
 * Default pipeline parameters. They can be overriden on the command line eg.
 * given `params.reads` specify on the run command line `--reads some_value`.
 */

params {
    // The input read-pair files
    reads: Path

    // The input transcriptome file
    transcriptome: Path

    // Directory containing multiqc configuration
    multiqc: Path = "${projectDir}/multiqc"
}


// import modules
include { RNASEQ } from './modules/rnaseq'
include { MULTIQC } from './modules/multiqc'

include { AlignedSample } from './modules/rnaseq'

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

    read_pairs_ch = channel.of(params.reads)
        .flatMap { csv -> csv.splitCsv() }
        .map { row -> row as List<String> }
        .map { row ->
            record(id: row[0], fastq_1: file(row[1], checkIfExists: true), fastq_2: file(row[2], checkIfExists: true))
        }

    samples_ch = RNASEQ(read_pairs_ch, params.transcriptome)

    multiqc_files_ch = samples_ch
        .flatMap { r -> [r.fastqc, r.quant] }
        .collect()

    multiqc_report = MULTIQC(multiqc_files_ch, params.multiqc)

    publish:
    samples = samples_ch
    multiqc_report = multiqc_report
}

/* 
 * workflow outputs
 */
output {
    samples: Channel<AlignedSample> {
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
    }
}
