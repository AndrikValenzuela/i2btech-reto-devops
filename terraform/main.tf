resource "kubernetes_namespace" "app" {
  metadata {
    name = var.namespace
  }
}

resource "tls_private_key" "ingress" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ingress" {
  private_key_pem = tls_private_key.ingress.private_key_pem

  subject {
    common_name  = var.ingress_host
    organization = "i2btech-devops"
  }

  dns_names             = [var.ingress_host]
  validity_period_hours = 8760
  early_renewal_hours   = 720

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "kubernetes_secret" "tls" {
  metadata {
    name      = "i2btech-app-tls"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  type = "kubernetes.io/tls"

  data = {
    "tls.crt" = tls_self_signed_cert.ingress.cert_pem
    "tls.key" = tls_private_key.ingress.private_key_pem
  }
}

resource "kubernetes_secret" "basic_auth" {
  metadata {
    name      = "i2btech-basic-auth"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    auth = var.basic_auth_htpasswd
  }
}

resource "helm_release" "app" {
  name      = var.release_name
  namespace = kubernetes_namespace.app.metadata[0].name
  chart     = var.chart_path

  values = [
    yamlencode({
      image = {
        repository = var.image_repository
        tag        = var.image_tag
        pullPolicy = "Never"
      }
      ingress = {
        enabled   = true
        className = "nginx"
        host      = var.ingress_host
        tls = {
          enabled        = true
          existingSecret = kubernetes_secret.tls.metadata[0].name
        }
      }
      basicAuth = {
        enabled        = true
        existingSecret = kubernetes_secret.basic_auth.metadata[0].name
        realm          = "Private"
      }
      persistence = {
        enabled          = true
        storageClassName = "manual"
        hostPath         = var.host_path
        size             = "1Gi"
        accessModes      = ["ReadWriteOnce"]
      }
    })
  ]

  depends_on = [
    kubernetes_secret.tls,
    kubernetes_secret.basic_auth,
  ]
}
