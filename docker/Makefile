all: build push

build:
	cp ../conda.yml .
	docker build -t nextflow/rnaseq-nf:latest .
	
push:
	docker tag nextflow/rnaseq-nf:latest quay.io/nextflow/rnaseq-nf
	docker push quay.io/nextflow/rnaseq-nf