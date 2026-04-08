include { INDEX } from '../../../modules/local/index'
include { QUANT } from '../../../modules/local/quant'
include { FASTQC } from '../../../modules/local/fastqc'

workflow RNASEQ {
    take:
    read_pairs_ch
    transcriptome

    main:
    index = INDEX(transcriptome)
    fastqc_ch = FASTQC(read_pairs_ch).logs
    quant_ch = QUANT(read_pairs_ch, index).quant
    samples_ch = fastqc_ch
        .join(quant_ch, by: 0)
        .map { id, fastqc, quant ->
            [id: id, fastqc: fastqc, quant: quant]
        }

    emit:
    samples = samples_ch
}
