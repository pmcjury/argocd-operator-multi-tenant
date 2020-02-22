#!/usr/bin/env bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..

# mkdir -p generated
# curl -L https://raw.githubusercontent.com/argoproj/argo-cd/v1.4.2/manifests/install.yaml -o generated/install.yaml
# curl -L https://raw.githubusercontent.com/argoproj/argo-cd/v1.4.2/manifests/ha/install.yaml -o generated/ha-install.yaml

# cert manager
curl -L https://github.com/jetstack/cert-manager/releases/download/v0.13.1/cert-manager.yaml -o $BASE_DIR/cert-manager/cert-manager-v0.13.1-upstream.yaml

# nginx
curl -L https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.29.0/deploy/static/mandatory.yaml -o $BASE_DIR/ingress-nginx/nginx-0.29.0-mandatory-upstream.yaml

curl -L https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.29.0/deploy/static/provider/cloud-generic.yaml -o $BASE_DIR/ingress-nginx/nginx-0.29.0-cloud-generic-upstream.yaml
