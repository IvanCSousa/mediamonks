
# rota que será usa pela rede NAT do Cluster GKE
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router.html
resource "google_compute_router" "router" {
  project = var.project_id
  name    = "nat-router"
  network = google_compute_network.vpc.name
  region  = var.region
}

# criação da NAT utilizando modulo TERRAFORM
#https://github.com/terraform-google-modules/terraform-google-cloud-nat
module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    =  " ~> 1.2"
  project_id = var.project_id
  region     = var.region
  router     = google_compute_router.router.name
}