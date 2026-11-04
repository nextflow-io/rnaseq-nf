#!/usr/bin/env bash
# Provision Nextflow, nf-test and the Seqera CLI inside the dev container.
set -euo pipefail

# xdg-utils provides `xdg-open`, which the Seqera CLI uses to open the browser
# during `seqera login`. Without it the CLI crashes instead of falling back to
# the printed auth URL (the OAuth callback port is forwarded by VS Code).
echo "Installing OS dependencies..."
sudo apt-get update -qq
sudo apt-get install -y -qq xdg-utils

echo "Installing Nextflow (NXF_VER=${NXF_VER:-latest})..."
curl -s https://get.nextflow.io | bash
sudo mv nextflow /usr/local/bin/
nextflow -version

echo "Installing nf-test..."
curl -fsSL https://get.nf-test.com | bash
sudo mv nf-test /usr/local/bin/
nf-test version

echo "Installing Seqera CLI..."
npm install -g seqera
seqera --version || true

echo "Dev container setup complete."
