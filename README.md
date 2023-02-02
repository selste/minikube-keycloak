# minikube-keycloak

Keycloak Deployment on Minikube, using [Argo CD](https://argoproj.github.io/cd/) and [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)

## Prerequisites

Misc. stuff:
- [minikube](https://minikube.sigs.k8s.io/docs/)
- [helm](https://helm.sh/)
- [kubectl](https://kubernetes.io/de/docs/tasks/tools/install-kubectl/)
- [kubeseal](https://github.com/bitnami-labs/sealed-secrets)
- [argocd (CLI)](https://argo-cd.readthedocs.io/en/stable/cli_installation/)

Kubernetes:
- Argo CD operator is installed in the cluster, see e.g. [Argo CD Overview](https://kubebyexample.com/learning-paths/argo-cd/argo-cd-overview)
- The Sealed Secrets operator is installed in the cluster.
  
  I'm using the Helm chart provided by Bitnami (because i'm lazy), but the operator is installed into a separate namespace:

  ```bash
  helm repo add bitnami https://charts.bitnami.com/bitnami
  ```

  ```bash
  helm repo update bitnami
  ```

  ```bash
  kubectl create namespace sealed-secrets
  ```

  ```bash
  helm install agentx -n sealed-secrets --set-string fullnameOverride=sealed-secrets-controller bitnami/sealed-secrets
  ```

## Deployment

- Create namespace
  ```bash
  kubectl create namespace neverland
  ```
- Create secret in namespace that contains the password for the Keycloak admin account, this will later be replaced with a sealed secret
  ```bash
  kubectl create secret generic keycloak-secret --from-literal=adminPassword=[top secret password] -n neverland
  ```
- Create new application via Argo CD web frontend
