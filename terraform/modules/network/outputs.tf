output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "web_subnet_id" {
  value = azurerm_subnet.web.id
}

output "database_subnet_id" {
  value = azurerm_subnet.database.id
}
