version ?= v1.1

all: build push

build:
	cp ../conda.yml .
	docker build --output=type=docker --progress=plain --tag quay.io/nextflow/rnaseq-nf:${version} .
	
push:
	docker push quay.io/nextflow/rnaseq-nf:${version}
