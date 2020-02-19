# argocd-operator-multi-tenant

## Order of Operations

- install

## Notes

https://argocd-operator.readthedocs.io/en/latest/

- Define DNS at your provider and point to cluster or external-dns
- add hostnames to install/argocd/argocd-TYPE.yaml
- Gather Github App client and secrets for dex
  - add it to install/argocd/argocd-TYPE.yaml
- Add Github Personal Access token add it to install/argocd/argocd-TYPE.yaml repo config
- Add any external clusters to

https://operatorhub.io/

clusters/base/cluster/team1/argocd-app
-> app1-repo/base/apps/

add clusters
https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#clusters

https://argocd-operator.readthedocs.io/en/latest/
