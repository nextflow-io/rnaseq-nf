FROM continuumio/miniconda
MAINTAINER Paolo Di Tommaso <paolo.ditommaso@gmail.com>

RUN conda config --add channels conda-forge \
 && conda config --add channels bioconda \
 && conda install -y salmon=0.8.2 fastqc=0.11.5 multiqc=1.1 \
 && conda clean -a

RUN apt-get -y install ttf-dejavu
