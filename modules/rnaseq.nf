include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
    take:
    read_pairs_ch
    transcriptome

    main:
    index = INDEX(transcriptome)
    fastqc_ch = FASTQC(read_pairs_ch)
    quant_ch = QUANT(read_pairs_ch, index)

    emit:
    fastqc = fastqc_ch
    quant = quant_ch
}
