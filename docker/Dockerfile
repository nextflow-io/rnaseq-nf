#
# don't waste your time with this
# use seqera containers https://seqera.io/containers/
#
FROM mambaorg/micromamba:1.5.10-noble

ARG MAMBA_USER=mambauser
ENV MAMBA_USER=${MAMBA_USER}


COPY --chown=$MAMBA_USER:$MAMBA_USER conda.yml /tmp/conda.yml
RUN micromamba install -y -n base -f /tmp/conda.yml \
    && micromamba install -y -n base conda-forge::procps-ng \
    && micromamba clean -a -y

ENV PATH="$MAMBA_ROOT_PREFIX/bin:$PATH"
USER root
