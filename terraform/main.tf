# `terraform/main.tf`

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Provider configuration for Azure
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Call the network module
module "network" {
  source = "./modules/network"

  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  vnet_name            = var.vnet_name
  web_subnet_name      = var.web_subnet_name
  database_subnet_name = var.database_subnet_name
}

# Call the database module
module "database" {
  source = "./modules/database"

  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  sql_db_name            = var.sql_db_name
  sql_server_name        = var.sql_server_name
  sql_admin_username     = var.sql_admin_username
  sql_admin_password     = var.sql_admin_password
  database_subnet_id     = module.network.database_subnet_id
}

# Call the security module
module "security" {
  source = "./modules/security"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  vnet_id             = module.network.vnet_id
  web_subnet_id       = module.network.web_subnet_id
  app_gateway_name    = var.app_gateway_name
  sql_server_id       = module.database.sql_server_id
  key_vault_name      = var.key_vault_name
}

# Call the compute module
module "compute" {
  source = "./modules/compute"

  resource_group_name     = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  app_service_plan_name   = var.app_service_plan_name
  web_app_name            = var.web_app_name
  web_subnet_id           = module.network.web_subnet_id
  sql_server_name         = module.database.sql_server_name
  sql_db_name             = module.database.sql_db_name
  sql_admin_username      = var.sql_admin_username
  sql_admin_password      = var.sql_admin_password
  key_vault_id            = module.security.key_vault_id
  key_vault_secrets       = module.security.key_vault_secrets
  application_gateway_id  = module.security.application_gateway_id
}