nextflow.preview.types = true

include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
    take:
    read_pairs_ch: Channel<Tuple<String, Path, Path>>
    transcriptome: Path

    main:
    index = INDEX(transcriptome)
    fastqc_ch = FASTQC(read_pairs_ch).logs
    quant_ch = QUANT(read_pairs_ch, index).quant

    emit:
    fastqc: Channel<Tuple<String, Path>> = fastqc_ch
    quant: Channel<Tuple<String, Path>> = quant_ch
}
