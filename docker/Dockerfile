FROM continuumio/miniconda
MAINTAINER Paolo Di Tommaso <paolo.ditommaso@gmail.com>

RUN apt-get -y install ttf-dejavu

COPY conda.yml .
RUN \
   conda env update -n root -f conda.yml \
&& conda clean -a
