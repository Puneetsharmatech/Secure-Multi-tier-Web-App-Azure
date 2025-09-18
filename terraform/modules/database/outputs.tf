output "sql_server_id" {
  value = azurerm_postgresql_flexible_server.main.id
}

output "sql_server_name" {
  value = azurerm_postgresql_flexible_server.main.name
}

output "sql_db_name" {
  value = azurerm_postgresql_flexible_server_database.db.name
}