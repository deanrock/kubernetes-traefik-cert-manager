# Kubernetes + Traefik + cert-manager

This example sets up:
* DigitalOcean
  * Kubernetes cluster
  * Domain record for *.example.test
* Kubernetes
  * Traefik as ingress
  * cert-manager
* `whoami` app accessible at `*.example.test` with LetsEncrypt cert

## Instructions

1. Prepare `terraform.tfvars` with the following content:
   ```
   prefix            = "test"
   domain            = "example.test"
   letsencrypt_email = "test@example.test"
   ```

2. Generate token on DO, and expose it via `DIGITALOCEAN_TOKEN` variable.

3. Run Terraform
   ```
   terraform init
   terraform plan -out=./plan
   terraform apply ./plan
   ```
