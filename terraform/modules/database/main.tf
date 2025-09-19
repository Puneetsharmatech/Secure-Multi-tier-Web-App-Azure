# Create the PostgreSQL server
resource "azurerm_postgresql_flexible_server" "main" {
  name                   = var.sql_server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "13"
  administrator_login    = var.sql_admin_username
  administrator_password = var.sql_admin_password

  storage_mb = 32768           # 32 GB
  sku_name   = "B_Standard_B1ms" # Basic tier for cost-effectiveness
  tags = {
    "project" = "Secure-Multi-tier-Web-App"
  }
}

# Create the database on the server
resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.sql_db_name
  server_id = azurerm_postgresql_flexible_server.main.id
}

