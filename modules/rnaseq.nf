
include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
    take:
    transcriptome
    samples_ch

    main:
    INDEX(transcriptome)
    FASTQC(samples_ch)
    QUANT(INDEX.out, samples_ch)

    emit:
    quant = QUANT.out
    fastqc = FASTQC.out
}
