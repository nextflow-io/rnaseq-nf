FROM mambaorg/micromamba
MAINTAINER Paolo Di Tommaso <paolo.ditommaso@gmail.com>

RUN \
   micromamba install -y -n base -c defaults -c bioconda -c conda-forge \
      salmon=1.10.2 \
      fastqc=0.12.1 \
      multiqc=1.15 \
   && micromamba clean -a -y

ENV PATH /opt/conda/bin:$PATH
USER root
