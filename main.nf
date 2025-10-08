#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */


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

    read_pairs_ch = channel.fromPath(params.reads)
        .flatMap { csv -> csv.splitCsv() }
        .map { row -> row as Tuple<String,String,String> }
        .map { id, fastq_1, fastq_2 ->
            tuple(id, file(fastq_1, checkIfExists: true), file(fastq_2, checkIfExists: true))
        }

    samples_ch = RNASEQ(read_pairs_ch, params.transcriptome)

    multiqc_files_ch = samples_ch
        .flatMap { id, fastqc, quant -> [fastqc, quant].toSet() }
        .collect()

    multiqc_report = MULTIQC(multiqc_files_ch, params.multiqc)

    publish:
    samples = samples_ch.map { id, fastqc, quant -> [id: id, fastqc: fastqc, quant: quant] }
    multiqc_report = multiqc_report

    onComplete:
    log.info(
        workflow.success
            ? "\nDone! Open the following report in your browser --> ${workflow.outputDir}/multiqc_report.html\n"
            : "Oops .. something went wrong"
    )
}

/* 
 * workflow outputs
 */
output {
    samples: Channel<Map> {
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
