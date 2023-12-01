params.outdir = 'results'

include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

@WorkflowFn
def RNASEQ(transcriptome, read_pairs_ch) {
  INDEX(transcriptome)
  FASTQC(read_pairs_ch)
  QUANT(INDEX.out, read_pairs_ch)
    | concat(FASTQC.out)
    | collect
}