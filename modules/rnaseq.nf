
nextflow.enable.types = true

include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
    take:
    read_pairs_ch: Channel<Sample>
    transcriptome: Path

    main:
    index = INDEX(transcriptome)
    fastqc_ch = FASTQC(read_pairs_ch)
    quant_ch = QUANT(read_pairs_ch, index)
    samples_ch = fastqc_ch.join(quant_ch, by: 'id')

    emit:
    samples: Channel<AlignedSample> = samples_ch
}

record Sample {
    id: String
    fastq_1: Path
    fastq_2: Path
}

record AlignedSample {
    id: String
    fastqc: Path
    quant: Path
}
