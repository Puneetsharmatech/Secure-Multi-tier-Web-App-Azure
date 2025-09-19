
variable "web_subnet_id" {
  type = string
}

variable "key_vault_id" {
  type = string
}

variable "key_vault_secret_uri" {
  type = string
}

variable "application_gateway_id" {
  type = string
}




# `terraform/variables.tf`

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = "multi-tier-app-rg"
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
  default     = "eastus"
}

variable "app_service_plan_name" {
  description = "Name of the App Service Plan."
  type        = string
  default     = "multi-tier-app-plan"
}

variable "web_app_name" {
  description = "Globally unique name for the App Service."
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network."
  type        = string
  default     = "app-vnet"
}

variable "web_subnet_name" {
  description = "Name of the web tier subnet."
  type        = string
  default     = "web-subnet"
}

variable "database_subnet_name" {
  description = "Name of the database tier subnet."
  type        = string
  default     = "database-subnet"
}

variable "sql_db_name" {
  description = "Name of the PostgreSQL database."
  type        = string
  default     = "task-db"
}

variable "sql_server_name" {
  description = "Globally unique name for the PostgreSQL server."
  type        = string
}

variable "sql_admin_username" {
  description = "Admin username for the PostgreSQL server."
  type        = string
}

variable "sql_admin_password" {
  description = "Admin password for the PostgreSQL server."
  type        = string
  sensitive   = true
}

variable "key_vault_name" {
  description = "Globally unique name for the Azure Key Vault."
  type        = string
}

variable "app_gateway_name" {
  description = "Name of the Application Gateway."
  type        = string
}