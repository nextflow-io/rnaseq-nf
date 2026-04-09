#!/usr/bin/env nextflow 

nextflow.preview.types = true

record SampleReads {
    id: String
    fastq_1: Path
    fastq_2: Path?
}

record SampleArtifacts {
    id: String
    fastqc: Path
    quant: Path
}

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */


/*
 * Default pipeline parameters. They can be overriden on the command line eg.
 * given `params.foo` specify on the run command line `--foo some_value`.
 */

params {
    outdir: String = 'results'
    input: String = "${baseDir}/data/samplesheet.csv"
    transcriptome: Path = file("${baseDir}/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa")
    multiqc: Path = file("${baseDir}/multiqc")
}

include {
    paramsSummaryLog
    validateParameters
} from 'plugin/nf-schema'


// import modules
include { RNASEQ } from './subworkflows/local/rnaseq'
include { MULTIQC } from './modules/local/multiqc'

def resolveSamplePath(Path samplesheetDir, String samplePath, boolean required = true) {
    def rawPath = samplePath?.trim()
    if( !rawPath ) {
        assert !required : 'Encountered an empty optional FASTQ path in the samplesheet'
        return null
    }

    if( rawPath ==~ /^[A-Za-z][A-Za-z0-9+.-]*:\/\/.+/ ) {
        return file(rawPath, checkIfExists: true)
    }

    def candidate = file(rawPath)
    def resolved = candidate.isAbsolute() ? candidate : samplesheetDir.resolve(rawPath)
    return file(resolved.toString(), checkIfExists: true)
}

/* 
 * main script flow
 */
workflow {

    main:

    validateParameters()
    log.info paramsSummaryLog(workflow)

    def samplesheet = file(params.input, checkIfExists: true)
    def samplesheetDir = samplesheet.parent ?: baseDir

    read_pairs_ch = channel
        .of(samplesheet)
        .flatMap { csv -> csv.splitCsv(header: true) }
        .map { row ->
            record(
                id: row.sample as String,
                fastq_1: resolveSamplePath(samplesheetDir, row.fastq_1 as String),
                fastq_2: resolveSamplePath(samplesheetDir, row.fastq_2 as String, false)
            )
        }

    samples_ch = RNASEQ(read_pairs_ch, params.transcriptome)

    multiqc_files_ch = samples_ch
        .flatMap { sample ->
            def typedSample: SampleArtifacts = sample
            [typedSample.fastqc, typedSample.quant]
        }
        .collect()
        .map { logs -> logs.toSet() }

    multiqc_report_ch = MULTIQC(multiqc_files_ch, params.multiqc)

    publish:
    samples = samples_ch
    multiqc_report = multiqc_report_ch

    onComplete:
        log.info(
            workflow.success
                ? "\nDone! Open the following report in your browser --> ${workflow.outputDir}/multiqc_report.html\n"
                : "Oops .. something went wrong"
        )
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
