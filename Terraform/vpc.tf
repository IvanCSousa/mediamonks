#VPC particular para o projeto 
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network.html
resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = "${var.nameproject}-vpc"
  auto_create_subnetworks = false #definições em google_compute_subnetwork.subnet.link
}

# Subnet da VPC
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork.html
resource "google_compute_subnetwork" "subnet" {
  project = var.project_id
  name          = "${var.nameproject}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.0.0.0/24" #range de ips utizado nessa subnet 
}

# Criando Firewall para o tunelamento com o host para a conexão no cluster GKE
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall.html
resource "google_compute_firewall" "rules" {
  project = var.project_id
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"] #range que será criado o HOST
}
