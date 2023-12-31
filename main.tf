provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name = "tf_rg_blobs_store"
    storage_account_name = "tfstorageaccountpopuppop"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.96.0"
    }
  }
}

variable "imagebuild" {
  type = string
  description = "Latest image build"
}

variable "imagename" {
  type = string
  description = "Image name"
}

resource "azurerm_resource_group" "tf_test" {
    name = "tfmainresourcegroup"
    location = "centralus"
}

resource "azurerm_container_group" "tfcg_group" {
  name = var.imagename
  location = azurerm_resource_group.tf_test.location
  resource_group_name = azurerm_resource_group.tf_test.name
  
  ip_address_type = "Public"
  dns_name_label = "popuppopwa"
  os_type = "Linux"

  container {
      name = var.imagename
      image = "popuppop/${var.imagename}:${var.imagebuild}"
      cpu = "1"
      memory = "1"
      environment_variables = {
        "WEBSITES_CONTAINER_START_TIME_LIMIT" = 1800
      }

      ports {
        port = 80
        protocol = "TCP"
      } 
  }
}