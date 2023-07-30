#Carregamento das variáveis do projeto
variable "project_id" {
  description = "Descrição do Projeto"
}

variable "region" {
  default = "us-central1"
  description = "Região do Cluster"
}

variable "zone" {
  default = "us-central1-c"
  description = "Zona do Cluster"
}

variable "num_nodes" {
  default     = 2
  description = "número de nós no GKE"
}

variable "nameproject" {
  default     = ""
  description = "Nome do projeto que será usado"
}

# Provider Google usando key do SA criado do Terraform
provider "google" {
  credentials = file("key.json") #KEY.JSON gerado no Service Account Terraform (Arquivo na mesma pasta que o arquvio)
  project = var.project_id
  region  = var.region
}