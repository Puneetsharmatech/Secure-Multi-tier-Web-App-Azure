variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "db_connection_string" {
  type      = string
  sensitive = true
}

variable "sql_server_id" {
  type = string
}

variable "database_subnet_id" {
  type = string
}

variable "web_subnet_id" {
  type = string
}

variable "app_gateway_name" {
  type = string
}
variable "vnet_id" {
  description = "The ID of the Virtual Network."
  type        = string
}