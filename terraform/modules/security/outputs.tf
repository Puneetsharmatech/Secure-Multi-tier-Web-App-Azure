output "key_vault_id" {
  value = azurerm_key_vault.main.id
}

output "db_connection_string_secret_name" {
  value = azurerm_key_vault_secret.db_connection_string.name
}

output "application_gateway_id" {
  value = azurerm_application_gateway.main.id
}

output "application_gateway_public_ip" {
  value = azurerm_public_ip.app_gateway_ip.ip_address
}