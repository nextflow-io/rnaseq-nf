version ?= v1.3.1

all: build push

build:
	cp ../conda.yml .
	docker build --output=type=docker --progress=plain --tag docker.io/nextflow/rnaseq-nf:${version} .
	
push:
	docker push docker.io/nextflow/rnaseq-nf:${version}
