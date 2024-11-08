include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
  take:
  pairs         : Channel<FastqPair>
  transcriptome : Path
 
  main: 
  def index = INDEX( transcriptome )    // Path (future)

  def samples = pairs.map { (id, fastq_1, fastq_2) ->
    def fastqc = FASTQC(id, fastq_1, fastq_2)
    def quant = QUANT(index, id, fastq_1, fastq_2)
    new Sample(id, fastqc, quant)
  }                                     // Channel<Sample>

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