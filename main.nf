#!/usr/bin/env nextflow 

nextflow.preview.types = true

record SampleReadPair {
    id: String
    fastq_1: Path
    fastq_2: Path
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
    reads: String = "${baseDir}/data/ggal/ggal_gut_{1,2}.fq"
    transcriptome: Path = file("${baseDir}/data/ggal/ggal_1_48850000_49020000.Ggal71.500bpflank.fa")
    multiqc: Path = file("${baseDir}/multiqc")
}


// import modules
include { RNASEQ } from './subworkflows/local/rnaseq'
include { MULTIQC } from './modules/local/multiqc'

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
      outputDir    : ${workflow.outputDir}
    """.stripIndent()

    read_pairs_ch = channel
        .fromFilePairs(params.reads, checkIfExists: true, flat: true)
        .map { id: String, fastq_1: Path, fastq_2: Path ->
            record(id: id, fastq_1: fastq_1, fastq_2: fastq_2)
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
