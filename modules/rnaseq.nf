
include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
    take:
    transcriptome
    samples_ch

    main:
    index = INDEX(transcriptome)
    fastqc_ch = FASTQC(samples_ch)
    quant_ch = QUANT(index, samples_ch)
    samples_ch = fastqc_ch.join(quant_ch)

    emit:
    samples_ch
}