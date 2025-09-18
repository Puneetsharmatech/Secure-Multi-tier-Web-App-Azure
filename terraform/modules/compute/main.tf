# Create the App Service Plan
resource "azurerm_service_plan" "app_plan" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "B1" # Basic tier for cost-effectiveness
}

# Create the Web App
resource "azurerm_linux_web_app" "app" {
  name                = var.web_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.app_plan.id
  https_only          = true

  site_config {
    application_stack {
      docker_image = "multi-tier-app"
      docker_image_tag = "latest"
    }
  }

  # VNet Integration for private access to the database
  virtual_network_subnet_id = var.web_subnet_id

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"        = "https://<your_acr_name>.azurecr.io"
    "DOCKER_REGISTRY_SERVER_USERNAME"   = "<acr_username>"
    "DOCKER_REGISTRY_SERVER_PASSWORD"   = "<acr_password>"
    # App Setting for the database connection string, pointing to Key Vault
    "DB_CONNECTION_STRING" = "@Microsoft.KeyVault(SecretUri=${var.key_vault_secret_uri})"
  }

  identity {
    type = "SystemAssigned"
  }
}

# Add the Web App's managed identity to Key Vault access policies
resource "azurerm_key_vault_access_policy" "key_vault_access" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.app.identity[0].principal_id

  secret_permissions = [
    "Get",
  ]
}

# Link the App Service to the Application Gateway Backend Pool
resource "azurerm_application_gateway_backend_address_pool_backend_address" "web_app_address" {
  address                    = azurerm_linux_web_app.app.default_hostname
  backend_address_pool_id    = var.application_gateway_id
}