KB = kustomize build
MK = argocd
LOCAL_DOMAIN = test
ARGOCD_DEP_NAME = example-argocd
 
.PHONY: default omnibus mk-init mk-rm mk-stop mk-addons-list mk-ip mk-argocd-login-password mk-argocd-login mk-argocd-open install install-argocd-cli install-olm install-argocd-operator install-argocd-instance delete help

default: help

omnibus: mk-init install ## Omnibus installer 

mk-init: ## Initialize olm, argocd operatorm, argocd, etc. deployed to minikube
	@echo "#### Initializing minikube, enabling addons, and configuring dns ( this can take some time ) ..."
	@minikube start -p $(MK) --cpus=4 --disk-size=40gb --memory=8gb
	@sleep 5
	@minikube addons -p $(MK) enable ingress
	@sleep 5
	@minikube addons -p $(MK) enable ingress-dns
	@sleep 5
	@echo "#### Adding ingress-dns add on entry to dns resolvers. Allows you to resolve 'http://*.test'"
	@echo "domain $(LOCAL_DOMAIN)\nnameserver `minikube ip -p $(MK)`\nsearch_order 1\ntimeout 5" | sudo tee /etc/resolver/minikube-$(MK)-test
	@minikube addons list -p $(MK)

mk-rm: ## Delete the argocd minikube
	@minikube delete -p $(MK)

mk-start: ## Start minikube
	@minikube start -p $(MK)

mk-stop: ## Stop minikube
	@minikube stop -p $(MK)

mk-addons-list: ## Dispaly minikube addons
	@minikube addons list -p $(MK)

mk-ip: ## Dispaly minikube ip
	@minikube ip -p $(MK)

mk-argocd-login-password: ## Dispaly the argocd login password deployed to minikube
	@echo "admin"
	@kubectl get pods -n argocd -l app.kubernetes.io/name=$(ARGOCD_DEP_NAME)-server -o name | cut -d'/' -f 2

mk-argocd-login: ## Login to argocd deployed to minikube
	@argocd login argocd-grpc.test \
		--insecure \
		--username admin \
		--password $(kubectl get pods -n argocd -l app.kubernetes.io/name=$(ARGOCD_DEP_NAME)-server -o name | cut -d'/' -f 2)

mk-argocd-open: mk-argocd-login-password ## Open ArgoCD UI deployed to minikube
	open http://argocd.test/login

install: install-olm install-argocd-operator install-argocd-instance ## Install all resources olm, argocd operator, argo, etc.

install-argocd-cli: ## Install the argocd cli
	@echo "#### Installing argocd-cli via homebrew"
	@brew tap argoproj/tap
	@brew install argoproj/tap/argocd	

install-olm: ## Install operator lifecycle manager
	@echo "#### Installing operator lifecycle manager (olm) ..."
	@kubectl apply -f ./install/olm/crds
	@kubectl apply -f ./install/olm/olm
	@sleep 2

install-argocd-operator: ## Install the argocd operator
	@echo "#### Installing argocd operator"
	@echo "#### Checking olm is installed and ready"
	@kubectl rollout status -w -n olm deployment/olm-operator
	@kubectl rollout status -w -n olm deployment/catalog-operator
	@kubectl wait --for=condition=ready --timeout=60s -n olm -l olm.catalogSource=argocd-catalog pod
	@$(KB) ./install/argocd-operator| kubectl apply -f -
	@sleep 15

install-argocd-instance: ## Install the argocd instances
	@echo "#### Installing argocd instance via argocd operator"
	@$(KB) ./install/argocd | kubectl apply -f -
	@sleep 5

delete: ## Delete all k8s resources for argocd, the operator, and olm
	@echo "#### To delete all argocd run the following"
	$(KB) ./install/argocd | kubectl delete -f -
	$(KB) ./install/argocd-operator | kubectl delete -f -
	kubectl delete -f ./install/olm

flush-dns-cache:
	sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
