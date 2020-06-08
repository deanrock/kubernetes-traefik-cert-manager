resource "digitalocean_domain" "domain" {
  name = var.domain
}

resource "digitalocean_record" "domain" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "@"
  ttl    = "300"
  value  = data.kubernetes_service.traefik.load_balancer_ingress.0.ip
}

resource "digitalocean_record" "wildcard" {
  domain = digitalocean_domain.domain.name
  type   = "A"
  name   = "*"
  ttl    = "300"
  value  = data.kubernetes_service.traefik.load_balancer_ingress.0.ip
}
