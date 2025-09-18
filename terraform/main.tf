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

# Retrieve the current client configuration for tenant ID
data "azurerm_client_config" "current" {}

# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Generate a random password for the database if one isn't provided
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$"
}

# The database connection string that will be stored in Key Vault
# Note: It's important to use the FQDN of the PostgreSQL server.
locals {
  db_connection_string = "postgresql://${var.sql_admin_username}:${random_password.db_password.result}@${module.database.sql_server_name}.postgres.database.azure.com:5432/${module.database.sql_db_name}"
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

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sql_db_name         = var.sql_db_name
  sql_server_name     = var.sql_server_name
  sql_admin_username  = var.sql_admin_username
  sql_admin_password  = random_password.db_password.result
}

# Call the security module
# debugginh
module "security" {
  source = "./modules/security"

  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  vnet_id              = module.network.vnet_id
  web_subnet_id        = module.network.web_subnet_id
  database_subnet_id   = module.network.database_subnet_id
  app_gateway_name     = var.app_gateway_name
  sql_server_id        = module.database.sql_server_id
  key_vault_name       = var.key_vault_name
  db_connection_string = local.db_connection_string
}

# Call the compute module
module "compute" {
  source = "./modules/compute"

  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  app_service_plan_name  = var.app_service_plan_name
  web_app_name           = var.web_app_name
  web_subnet_id          = module.network.web_subnet_id
  key_vault_id           = module.security.key_vault_id
  key_vault_secret_uri   = "${module.security.key_vault_id}/secrets/${module.security.db_connection_string_secret_name}"
  application_gateway_id = module.security.application_gateway_id
}