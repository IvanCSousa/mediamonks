Esse projeto tem como proposta:
    
    - Construir um Cluster Privado GKE, com uma VPC Privada e utiliando uma VM como host
    para acessar o cluster de forma segura utilizando Terraform.
    
    - Inserir uma aplicação simples (Hello Word), sendo uma imagem do repositório DockerHub, utilizando 
    objetos e serviços k8s.

    - Expor essa aplicação de forma segura utilizando o NGINX INGRESS CONTROLLER

Esse documento serve como um guia para fazer aplicar do projeto conforme os passos a seguir

1. No GCP
    1.1 - Criar projeto 
        https://cloud.google.com/appengine/docs/standard/python3/building-app/creating-gcp-project?hl=pt-br
   
    1.2 Ativar APIs Kubernetes Engine(GKE), Compute Enginee (CE) e Identity-Aware Proxy (IAP)
        https://cloud.google.com/apis/docs/overview?hl=pt-br

    1.3 Crie uam Service Account para o Terraform 
        https://developer.hashicorp.com/terraform/tutorials/gcp-get-started 

        1.3.1 Aplicar a role de Project - edit no SA do Terraform 
        https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build
        1.3.2 Gerar e aplicar a key.json no diretório do projeto Terraform
        1.3.3 Aplicar roles de IAP.tunnel no usuário de usuário 
        https://cloud.google.com/iap/docs/using-tcp-forwarding?hl=pt-br
    
3. ARQUIVOS TERRAFORM
    2.1. Inserir o id do projeto no arquivo de variáveis do Terraform
        obs.: O git instalado é um pré-requisito para fazer dowloads dos modulos necessários
   
    2.2. No diretório Terraform executar os seguintes comandos
        2.2.1 Inicializa o provider e faz dowloads dos modulos
               $ terraform init
        2.2.2 Planejar a aplicação no ambiente terraform
               $ terraform plan
        2.2.3 Aplicando o projeto terraform no GCP
               $ terraform aplay
        obs.: Espere o processo terminar, isso pode demorar um pouco

5. NO GCP
    3.1 Entrar no Host criado Compute Enginee (nomeado no arquivo Host.tf)
        3.1.1 - No caso testado foi utilizado o Cloud Shell da VM Host
    3.2 Baixar o kubectl no HOST - sudo apt-get install kubectl
    3.3 Fazer a autetificação - gcloud auth login
    3.4 Caso necessário aplicar o SDK GKE - sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
    3.5 Fazer o Tunelamento/Jump para o Cluster GKE - "ex: gcloud container clusters get-credentials monks-cluster --zone us-central1-c --project monksproject"


    3.6 NGINX ingress Controlle
        3.6.1 Instalar o HELM na VM
            $ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
            $ chmod 700 get_helm.sh
            $ ./get_helm.sh

        3.6.2 Aplicando o Charts do Ingress Nginx Controller 
                $ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
                $ helm repo update
                $ helm install monks ingress-nginx/ingress-nginx
            
        3.6.3 - Anote o EXTERNAL-IP do Service do monks-ingress-nginx-clontroller  
                $ kubectl get svc monks-ingress-nginx-clontroller

6. APP
    4.1 Aplicar  os objeto kubernetes - arquivo k8s/monk.yalm - kubectl apply -f monk.yalm
    obs.: Necessário que o arquivo esteja dentro da VM Host
    
    4.2 Necessário mudar o host do ingress para o endereço EXTERNAL-IP copiado no  item 3.6.3
    obs.: utilize o nip.io - ex: "34.122.88.204.nip.io"
    4.3 Aplicar o Ingress_monks.yalm - kubectl apply -f ingress_monks.yaml

    https://cloud.google.com/community/tutorials/nginx-ingress-gke / Deploy an application in Google Kubernetes Engine

7. Acesso/Teste 
    5.1 Em seu Browser digite o endereço utilizado no Host - ex: "34.122.88.204.nip.io"

8. Deletar projeto
    6.1 Utilize o Destroy do Terrafom 
        $ terraform destroy
    obs. Espere o processo terminar, isso pode demorar um pouco
    6.2 No GCP 
        6.2.1 - Entre no Faturamento e desative o projeto criado em ações
        6.2.2 - Entre em IAMe Administração/Configurações e encerre o projeto


REF.:   https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build
        https://cloud.google.com/community/tutorials/nginx-ingress-gke
        https://medium.com/google-cloud/gcp-terraform-to-deploy-private-gke-cluster-bebb225aa7be
