terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "kml_rg_main-db2e80381d984b08" # Your resource group name
    storage_account_name = "puneetuniqueacct01" # Your globally unique storage account name
    container_name       = "tfstateforterraform" # Your container name
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

