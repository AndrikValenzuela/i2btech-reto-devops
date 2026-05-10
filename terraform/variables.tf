variable "kubeconfig_path" {
  type        = string
  description = "Path to the kubeconfig file used by Terraform providers."
  default     = "~/.kube/config"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace for the application."
  default     = "i2btech"
}

variable "release_name" {
  type        = string
  description = "Helm release name."
  default     = "i2btech"
}

variable "chart_path" {
  type        = string
  description = "Local path to the Helm chart."
  default     = "../helm/i2btech-app"
}

variable "image_repository" {
  type        = string
  description = "Container image repository."
  default     = "i2btech-reto-devops"
}

variable "image_tag" {
  type        = string
  description = "Container image tag."
  default     = "local"
}

variable "ingress_host" {
  type        = string
  description = "Hostname exposed by the Kubernetes ingress."
  default     = "i2btech.local"
}

variable "basic_auth_htpasswd" {
  type        = string
  description = "htpasswd-formatted content for nginx ingress basic auth."
  sensitive   = true
}

variable "host_path" {
  type        = string
  description = "HostPath used by the persistent volume for app logs."
  default     = "/data/i2btech-logs"
}
