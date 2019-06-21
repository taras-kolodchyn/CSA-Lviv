
# Configure the AzureAD Provider
provider "azuread" {
  subscription_id = "${var.subscription_id}"
}

# Configure the Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
}

 resource "azuread_application" "swc_reader" {
  name                       = "swc_reader"
  reply_urls                 = ["https://obsrvbl.com/azure-api/swc-reader"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
}

resource "azuread_service_principal" "swc_reader" {
  application_id = "${azuread_application.swc_reader.application_id}"
}

resource "azuread_service_principal_password" "swc_reader" {
  service_principal_id = "${azuread_service_principal.swc_reader.id}"
  value                = "bd018069-622d-4b46-bcb9-2bbee49fe7d9"
  end_date             = "2020-01-01T01:02:03Z"
}



# Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

resource "azurerm_resource_group" "rg_aks" {
  name     = "${var.prefix}k8s-resources"
  location = "${var.location}"
  tags = {
     Environment = "Demo"
     Groupe = "CSA-Lviv"
  }
}

# Create Storage Account

resource "azurerm_storage_account" "storage" {
  name                     = "csa${random_id.instance_id.hex}"
  resource_group_name      = "${azurerm_resource_group.rg_aks.name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name = "nsg-logs"
  resource_group_name   = "${azurerm_resource_group.rg_aks.name}"
  storage_account_name  = "${azurerm_storage_account.storage.name}"
  container_access_type = "private"
}

# Create AKS
resource "azurerm_kubernetes_cluster" "aks" { 
  name                = "${var.prefix}k8s-${random_id.instance_id.hex}"
  location            = "${azurerm_resource_group.rg_aks.location}"
  resource_group_name = "${azurerm_resource_group.rg_aks.name}"
  dns_prefix          = "${var.prefix}k8s-${random_id.instance_id.hex}"

  agent_pool_profile {
    name            = "default"
    count           = 2
    vm_size         = "Standard_D2s_v3"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = "${var.kubernetes_client_id}"
    client_secret = "${var.kubernetes_client_secret}"
  }

  tags = {
     Environment = "Demo"
     Groupe = "CSA-Lviv"
  }
}
