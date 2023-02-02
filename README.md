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

## Sealed secret

Find the canonical documentation (on the usage of kubeseal) [over there](https://github.com/bitnami-labs/sealed-secrets#usage)

- Create a regular Kubernetes secret in a local directory that's NOT under version control ... and don't forget setting the namespace
  ```bash
  echo -n [to secret password] | kubectl create secret generic keycloak-secret --dry-run=client --from-file=adminPassword=/dev/stdin -o yaml -n neverland > keycloak-secret.yaml
  ```
- Create a sealed secret using this file
  ```bash
  kubeseal --controller-namespace sealed-secrets --format yaml -f keycloak-secret.yaml > keycloak-sealed-secret.yaml
  ```
  which can be safely committed


## Deployment

- Create namespace
  ```bash
  kubectl create namespace neverland
  ```
- Create secret in namespace that contains the password for the default Keycloak admin account, from the sealed secret created earlier
  ```bash
  kubectl create -f keycloak-sealed-secret.yaml -n neverland
  ```
- Create the application
  ```bash
  kubectl apply -f application.yaml
  ```
