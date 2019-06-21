variable "subscription_id" {
}


variable "prefix" {
  description = "A prefix used for all resources in this example"
  default ="csa-"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default="westeurope"
}

variable "kubernetes_client_id" {
  description = "The Client ID for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "kubernetes_client_secret" {
  description = "The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster"
}


#Manually create a service principal
#https://docs.microsoft.com/en-us/azure/aks/kubernetes-service-principal
#az ad sp create-for-rbac --skip-assignment
#az aks install-cli
#az aks get-credentials --resource-group myResourceGroup --name myAKSCluster

