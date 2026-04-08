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

include { INDEX } from '../../../modules/local/index'
include { QUANT } from '../../../modules/local/quant'
include { FASTQC } from '../../../modules/local/fastqc'

workflow RNASEQ {
    take:
    read_pairs_ch: Channel<SampleReads>
    transcriptome: Path

    main:
    index = INDEX(transcriptome)
    fastqc_ch = FASTQC(read_pairs_ch)
    quant_ch = QUANT(read_pairs_ch, index)
    samples_ch = fastqc_ch
        .map { sample -> tuple(sample.id, sample.fastqc) }
        .join(
            quant_ch.map { sample -> tuple(sample.id, sample.quant) },
            by: 0
        )
        .map { id: String, fastqc: Path, quant: Path ->
            record(id: id, fastqc: fastqc, quant: quant)
        }

    emit:
    samples: Channel<SampleArtifacts> = samples_ch
}
