#Host utilizando para fazer o jump no cluster usando o tunelamento
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address.html
resource "google_compute_address" "internal_ip_addr" {
  project      = var.project_id
  address_type = "INTERNAL"
  region       = var.region #mesma região do cluster GKE
  subnetwork   = google_compute_subnetwork.subnet.name
  name         = "ip"
  address      = "10.0.0.7" #IP utilizado para permitir o aceess no GKE
  description  = "endereçamento para utilização do HOST connectar com o cluster GKE"
}
#Definição da Instância VM
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance.html
resource "google_compute_instance" "default" {
  project      = var.project_id
  zone         = var.zone #mesma zona do Cluster GK
  name         = "${var.nameproject}-host"
  machine_type = "e2-small" #Tipo de E2, podendo mudar por exemplo e2-micro
  #Definiçãod disk uilizado
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  #utilização da mesma vpc do GKE
  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.subnet.name 
    network_ip         = google_compute_address.internal_ip_addr.address
  }
}

