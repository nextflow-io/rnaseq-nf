Build & push the multi-arch (amd64 + arm64) image:

    make push version=v1.4.0

Local single-arch image for testing (host arch only):

    make build

Needs a buildx builder that supports multi-platform:

    docker buildx create --use --name rnaseq-nf --driver docker-container
