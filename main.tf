resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = var.prefix
  region  = var.region
  version = "1.17.5-do.0"
  tags    = []

  node_pool {
    name       = "${var.prefix}-worker"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
  }
}
