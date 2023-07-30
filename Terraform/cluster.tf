# GKE cluster
#https://registry.terraform.io/providers/hashicorp/google/3.14.0/docs/data-sources/google_container_cluster
resource "google_container_cluster" "cluster_monks" {
  name     = "${var.nameproject}-cluster"
  location = var.zone #Localização do nó, usando zone, porém para um cluster de alta disponibilidade/resiliente é indicado a criação por região 
  
  network    = google_compute_network.vpc.name #referenciando vpc já criada
  subnetwork = google_compute_subnetwork.subnet.name
  remove_default_node_pool = true
  initial_node_count       = 1
  #alocação de ip e definindo cluster privado e o ip
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "10.13.0.0/28"
  }
  #separando os ips do cluster
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.11.0.0/21"
    services_ipv4_cidr_block = "10.12.0.0/21"
  }
  # Autorização de access do host
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.0.0.7/32"
      display_name = "net1"
    }
  }
  networking_mode          = "VPC_NATIVE"
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  #release_channel {
  #  channel = "REGULAR"
  #}
  addons_config {
  #  http_load_balancing {
  #    disabled = true
  #  }
  #Habilitando o autoscaling dos pods
    horizontal_pod_autoscaling {
      disabled = false
    }
  }
}  

#configuração dos nodes utilizados no GKE
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool.html
resource "google_container_node_pool" "monks_nodes" {
  name       = "${google_container_cluster.cluster_monks.name}-pool"
  location   = var.zone 
  cluster    = google_container_cluster.cluster_monks.name
  node_count = var.num_nodes
  #Autoscaling do node, definindo o minimo e o máximo de nodes
   autoscaling {
    min_node_count = 1
    max_node_count = 3
  }
  #auto repar e upgrade dos nodes
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  #https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#nested_node_config
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    
    labels = {
      env = "dev"
    }
    #configurações das instâncias
    machine_type = "e2-small"
    
    disk_type = "pd-standard"
    disk_size_gb = 100
    preemptible  = true
    #tags         = ["cluster-node", "${google_container_cluster.cluster_monks.name}-cluster"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    
  }
}
