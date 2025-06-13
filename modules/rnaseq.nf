
include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
    take:
    reads         : Channel<FastqPair>
    transcriptome : Path

    main:
    index = INDEX(transcriptome)
    fastqc_ch = reads.map(FASTQC)
    quant_ch = reads.map(QUANT, index: index)
    samples_ch = fastqc_ch.join(quant_ch, 'id')

    emit:
    samples : Channel<Sample> = samples_ch
    index   : Path = index
}

record FastqPair {
  id      : String
  fastq_1 : Path
  fastq_2 : Path
}

record Sample {
  id      : String
  fastqc  : Path
  quant   : Path
}
