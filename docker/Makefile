version ?= v1.4.0
image ?= docker.io/nextflow/rnaseq-nf
platforms ?= linux/amd64,linux/arm64

all: push

# single-arch image loaded in the local docker daemon, for testing
build:
	cp ../conda.yml .
	docker buildx build --load --progress=plain --tag ${image}:${version} .

# ponytail: multi-arch manifests can't be --load'ed, so build+push is one step
push:
	cp ../conda.yml .
	docker buildx build --push --platform ${platforms} --progress=plain --tag ${image}:${version} .
