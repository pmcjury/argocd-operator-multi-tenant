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

192.168.128.0/28

gcloud compute firewall-rules create prometheus-operator-webhooks \
 --action ALLOW \
 --direction INGRESS \
 --source-ranges 192.168.128.0/28 \
 --rules tcp:8443 \
 --target-tags gke-nomad-health-dev-cluster-158097f1-node \
 --description "Allow Prometheus Operator webhooks"

gcloud compute firewall-rules create cert-operator-webhooks \
 --action ALLOW \
 --direction INGRESS \
 --source-ranges 192.168.128.0/28 \
 --target-tags gke-nomad-health-dev-cluster-158097f1-node \
 --description "Allow Cert Manager webhooks"

k port-forward -n argocd svc/argocd-server 8080:443
