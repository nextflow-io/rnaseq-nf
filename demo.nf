/*
 * Copyright (c) 2013-2019, Centre for Genomic Regulation (CRG) and the authors.
 *
 *   This file is part of 'RNASEQ-NF'.
 *
 *   RNASEQ-NF is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   RNASEQ-NF is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with RNASEQ-NF.  If not, see <http://www.gnu.org/licenses/>.
 */


/*
 * Proof of concept of a RNAseq pipeline implemented with Nextflow
 *
 * Authors:
 * - Paolo Di Tommaso <paolo.ditommaso@gmail.com>
 * - Emilio Palumbo <emiliopalumbo@gmail.com>
 * - Evan Floden <evanfloden@gmail.com>
 */

/* 
 * enables modules 
 */
nextflow.preview.dsl = 2

/*
 * Default pipeline parameters. They can be overriden on the command line eg.
 * given `params.foo` specify on the run command line `--foo some_value`.
 */

params.reads = "$baseDir/data/ggal/*_{1,2}.fq"
params.ref1 = "$baseDir/data/ggal/ref1.fa"
params.ref2 = "$baseDir/data/ggal/ref2.fa"
params.outdir = "results"
params.multiqc = "$baseDir/multiqc"

log.info """\
 R N A S E Q - N F   P I P E L I N E
 ===================================
 ref1:    : ${params.ref1}
 ref2:    : ${params.ref2}
 reads    : ${params.reads}
 outdir   : ${params.outdir}
 """

// import modules
include './modules/rnaseq' params(params)

workflow ref1 {
  get: reads
  main: RNASEQ( params.ref1, reads, params.multiqc)
}

workflow ref2 {
  get:reads 
  main: RNASEQ( params.ref2, reads, params.multiqc)
}

// main flow 
workflow {
  reads = Channel.fromFilePairs( params.reads, checkIfExists: true )
  ref1(reads)
  ref2(reads)
}

/* 
 * completion handler
 */
workflow.onComplete {
	log.info ( workflow.success ? "\nDone! Open the following report in your browser --> $params.outdir/multiqc_report.html\n" : "Oops .. something went wrong" )
}
