variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
  default     = "secure-app-rg"
}

variable "location" {
  description = "The Azure region to deploy resources."
  type        = string
  default     = "East US"
}