resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://containous.github.io/traefik-helm-chart"
  namespace  = kubernetes_namespace.ingress.metadata[0].name
  chart      = "traefik"
  version    = "8.3.0"

  depends_on = [
    digitalocean_kubernetes_cluster.cluster
  ]

  values = [
    yamlencode(
      {
        additionalArguments = [
          "--providers.kubernetesIngress.ingressClass=traefik",
          "--log.level=DEBUG"
        ]
      }
    )
  ]
}

data "kubernetes_service" "traefik" {
  metadata {
    name      = "traefik"
    namespace = "ingress"
  }

  depends_on = [helm_release.traefik]
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  namespace  = kubernetes_namespace.ingress.metadata[0].name
  chart      = "cert-manager"
  version    = "0.15.1"

  depends_on = [
    digitalocean_kubernetes_cluster.cluster
  ]

  values = [
    yamlencode(
      {
        leaderElection = {
          namespace = "ingress"
        },
        installCRDs = "true"
      }
    )
  ]
}

resource "helm_release" "acme-cluster-issuer" {
  name       = "acme-cluster-issuer"
  repository = "https://deanrock.github.io/acme-cluster-issuer-helm-chart/"
  namespace  = kubernetes_namespace.ingress.metadata[0].name
  chart      = "acme-cluster-issuer"
  version    = "0.1.3"

  depends_on = [
    digitalocean_kubernetes_cluster.cluster
  ]

  values = [
    yamlencode(
      {
        acme = {
          email = var.letsencrypt_email
        }
      }
    )
  ]
}

resource "helm_release" "whoami" {
  name      = "whoami"
  namespace = "default"
  chart     = "./charts/whoami"

  depends_on = [
    digitalocean_kubernetes_cluster.cluster
  ]

  values = [
    yamlencode(
      {
        domain = "whoami.${var.domain}"
        email  = var.letsencrypt_email
        ingress = {
          hosts = [
            {
              host = "whoami.${var.domain}",
              paths = [
                "/"
              ]
            }
          ]
          tls = [
            {
              secretName = "whoami-whoami-cert"
              hosts : [
                "whoami.${var.domain}"
              ]
            }
          ]
        }
      }
    )
  ]
}
