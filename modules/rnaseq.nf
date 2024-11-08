include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
  take:
  pairs         : Channel<FastqPair>
  transcriptome : Path
 
  main: 
  transcriptome               // Path
    |> INDEX                  // Path (future)
    |> set { index }          // Path (future)

  pairs                       // Channel<FastqPair>
    |> map { pair ->
      def (id, fastq_1, fastq_2) = (pair.id, pair.fastq_1, pair.fastq_2)
      def fastqc = FASTQC(id, fastq_1, fastq_2)
      def quant = QUANT(index, id, fastq_1, fastq_2)
      new Sample(id, fastqc, quant)
    }                         // Channel<Sample>
    |> set { samples }        // Channel<Sample>

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