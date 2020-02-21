#!/usr/bin/env bash

mkdir -p generated
curl -L https://raw.githubusercontent.com/argoproj/argo-cd/v1.4.2/manifests/install.yaml -o generated/install.yaml
curl -L https://raw.githubusercontent.com/argoproj/argo-cd/v1.4.2/manifests/ha/install.yaml -o generated/ha-install.yaml