#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */


/*
 * Default pipeline parameters. They can be overriden on the command line eg.
 * given `params.foo` specify on the run command line `--foo some_value`.
 */

params.outdir = 'results'
params.input = "${baseDir}/data/samplesheet.csv"
params.transcriptome = file("${baseDir}/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa")
params.multiqc = file("${baseDir}/multiqc")

include {
    paramsSummaryLog
    validateParameters
} from 'plugin/nf-schema'

// import modules
include { RNASEQ } from './subworkflows/local/rnaseq'
include { MULTIQC } from './modules/local/multiqc'

/* 
 * main script flow
 */
workflow {

    main:

    validateParameters()
    log.info paramsSummaryLog(workflow)

    def samplesheet = file(params.input, checkIfExists: true)
    def samplesheetDir = samplesheet.parent ?: baseDir

    read_pairs_ch = Channel
        .fromPath(samplesheet.toString(), checkIfExists: true)
        .splitCsv(header: true)
        .map { row ->
            def fastq1Path = row.fastq_1?.trim()
            def fastq2Path = row.fastq_2?.trim()
            assert fastq1Path : 'Encountered an empty FASTQ path in column fastq_1'
            assert fastq2Path : 'Encountered an empty FASTQ path in column fastq_2'

            def fastq1Candidate = file(fastq1Path)
            def fastq2Candidate = file(fastq2Path)
            def fastq1Resolved = fastq1Candidate.isAbsolute() ? fastq1Candidate : samplesheetDir.resolve(fastq1Path)
            def fastq2Resolved = fastq2Candidate.isAbsolute() ? fastq2Candidate : samplesheetDir.resolve(fastq2Path)

            tuple(
                row.sample as String,
                file(fastq1Resolved.toString(), checkIfExists: true),
                file(fastq2Resolved.toString(), checkIfExists: true)
            )
        }

    samples_ch = RNASEQ(read_pairs_ch, params.transcriptome)

    multiqc_files_ch = samples_ch
        .flatMap { sample -> [sample.fastqc, sample.quant] }
        .collect()
        .map { logs -> logs.toSet() }

    multiqc_report_ch = MULTIQC(multiqc_files_ch, params.multiqc)

    publish:
    samples = samples_ch
    multiqc_report = multiqc_report_ch
}

output {
    samples {
        path { sample ->
            sample.fastqc >> "fastqc/${sample.id}"
            sample.quant >> "quant/${sample.id}"
        }
        index {
            path 'samples.csv'
            header true
        }
    }

    multiqc_report {
        path '.'
    }
}
