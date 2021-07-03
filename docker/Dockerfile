FROM continuumio/miniconda:4.7.12
MAINTAINER Paolo Di Tommaso <paolo.ditommaso@gmail.com>

RUN apt-get -y install ttf-dejavu

COPY conda.yml .
RUN \
   conda env update -n root -f conda.yml \
&& conda clean -a

RUN apt-get install -y procps

