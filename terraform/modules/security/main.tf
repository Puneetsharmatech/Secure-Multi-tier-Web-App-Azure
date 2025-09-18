# Create the Azure Key Vault
resource "azurerm_key_vault" "main" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  soft_delete_retention_days = 7
}

# Key Vault secret for the database connection string
resource "azurerm_key_vault_secret" "db_connection_string" {
  name         = "db-connection-string"
  value        = var.db_connection_string
  key_vault_id = azurerm_key_vault.main.id
}

# Create a Private Endpoint for the PostgreSQL server
resource "azurerm_private_endpoint" "db" {
  name                = "db-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.database_subnet_id

  private_service_connection {
    name                           = "db-psc"
    is_manual_connection           = false
    private_connection_resource_id = var.sql_server_id
    subresource_names              = ["postgresqlServer"]
  }
}

# Deploy a Public IP for the Application Gateway
resource "azurerm_public_ip" "app_gateway_ip" {
  name                = "app-gateway-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# Create the Application Gateway with WAF
resource "azurerm_application_gateway" "main" {
  name                = var.app_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = "WAF_V2" # Includes WAF
    tier     = "WAF_V2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "default-gateway-ip-config"
    subnet_id = var.web_subnet_id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "public-ip-config"
    public_ip_address_id = azurerm_public_ip.app_gateway_ip.id
  }

  backend_address_pool {
    name = "web-app-pool"
  }

  backend_http_settings {
    name                  = "http-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "public-ip-config"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "web-app-pool"
    backend_http_settings_name = "http-settings"
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }
}

data "azurerm_client_config" "current" {}

