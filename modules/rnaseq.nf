params.outdir = 'results'

include { INDEX } from './index'
include { QUANT } from './quant'
include { FASTQC } from './fastqc'

workflow RNASEQ {
  take:
    transcriptome
    read_pairs_ch
 
  main: 
    INDEX(transcriptome)
    FASTQC(read_pairs_ch)
    QUANT(INDEX.out, read_pairs_ch)

  emit: 
     QUANT.out | concat(FASTQC.out) | collect
}