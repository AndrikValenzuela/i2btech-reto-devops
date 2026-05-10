output "urls" {
  value = {
    root         = "https://${var.ingress_host}/"
    public       = "https://${var.ingress_host}/public"
    private      = "https://${var.ingress_host}/private"
    health_check = "https://${var.ingress_host}/health_check"
  }
}
