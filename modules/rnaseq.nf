include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
    take:
    read_pairs_ch: Channel<Tuple<String,Path,Path>>
    transcriptome: Path

    main:
    index = INDEX(transcriptome)
    fastqc_ch = FASTQC(read_pairs_ch)
    quant_ch = QUANT(read_pairs_ch, index)
    samples_ch = fastqc_ch.join(quant_ch)

    emit:
    samples: Channel<Tuple<String,Path,Path>> = samples_ch
}
