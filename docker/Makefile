version ?= v1.0

all: build push

build:
	cp ../conda.yml .
	docker build -t quay.io/nextflow/rnaseq-nf:${version} .
	
push:
	docker push quay.io/nextflow/rnaseq-nf:${version}
