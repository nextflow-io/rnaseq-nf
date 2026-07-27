#
# don't waste your time with this
# use seqera containers https://seqera.io/containers/
#
FROM mambaorg/micromamba:2.8.1-ubuntu24.04

COPY --chown=$MAMBA_USER:$MAMBA_USER conda.yml /tmp/conda.yml
RUN micromamba install -y -n base -f /tmp/conda.yml \
    && micromamba install -y -n base conda-forge::procps-ng \
    && micromamba clean -a -y

ENV PATH="$MAMBA_ROOT_PREFIX/bin:$PATH"
USER root
