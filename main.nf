#!/usr/bin/env nextflow 

/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 */

nextflow.preview.types = true

/*
 * Import modules
 */

include { RNASEQ } from './modules/rnaseq'
include { MULTIQC } from './modules/multiqc'
include { Sample ; AlignedSample } from './modules/rnaseq'

/*
 * Default pipeline parameters. They can be overriden on the command line eg.
 * given `params.reads` specify on the run command line `--reads some_value`.
 */

params {
    // The input read-pair files
    reads: List<Sample>

    // The input transcriptome file
    transcriptome: Path

    // Directory containing multiqc configuration
    multiqc: Path = "${projectDir}/multiqc"
}


/* 
 * main script flow
 */
workflow {
    main:
    log.info """\
      R N A S E Q - N F   P I P E L I N E
      ===================================
      transcriptome: ${params.transcriptome}
      reads        : ${params.reads*.id}
      outdir       : ${workflow.outputDir}
    """.stripIndent()

    read_pairs_ch = channel.fromList(params.reads)

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
