include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
  take:
  pairs         : Channel<FastqPair>
  transcriptome : Path
 
  main: 
  index = INDEX(transcriptome)
  fastqc = pairs.map(FASTQC)
  quant = pairs.map(QUANT, index: index)
  samples = fastqc.join(quant, 'id')

  emit:
  index   : Path
  samples : Channel<Sample>
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