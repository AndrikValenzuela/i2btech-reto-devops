# i2btech DevOps Challenge

This repository contains the Docker, Helm, Terraform and Ansible assets needed to run the provided Node.js API.

## Local Docker Compose

```bash
docker compose up --build
```

The app is exposed through nginx over HTTPS:

- `https://localhost/`
- `https://localhost/public`
- `https://localhost/private`
- `https://localhost/health_check`

`/private` is protected with basic auth. Defaults are `devops/devops`; override them without committing secrets:

```bash
BASIC_AUTH_USER=myuser BASIC_AUTH_PASSWORD=mypassword docker compose up --build
```

Application logs are persisted in the named Docker volume `i2btech-reto-devops_app_logs`.

## Helm Chart

The chart lives in `helm/i2btech-app`. It deploys:

- the Node.js app as a Deployment and ClusterIP Service
- public and private nginx ingress rules
- TLS ingress support
- basic auth only for `/private`
- a hostPath-backed PersistentVolume/PersistentVolumeClaim mounted at `/app/logs`

## Terraform

Terraform deploys the Helm chart and creates runtime Kubernetes secrets for TLS and basic auth:

```bash
cd terraform
terraform init
TF_VAR_basic_auth_htpasswd="$(htpasswd -nbB devops devops)" terraform apply
```

## Ansible

The playbook assumes a fresh Ubuntu 24.04 host. It installs Docker, kubectl, Minikube, Helm and Terraform, starts a local Minikube cluster, builds the image inside Minikube, then deploys the app through Terraform and the local Helm chart.

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

After the playbook completes, these links are available in a browser:

- `https://i2btech.local/`
- `https://i2btech.local/public`
- `https://i2btech.local/private`
- `https://i2btech.local/health_check`

The default basic auth credentials are `devops/devops`. Override with Ansible extra vars:

```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml \
  -e basic_auth_user=myuser \
  -e basic_auth_password=mypassword
```
