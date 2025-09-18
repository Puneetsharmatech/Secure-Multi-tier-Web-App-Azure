resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

# Subnet for the web application
resource "azurerm_subnet" "web" {
  name                 = var.web_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  # Required for Private Endpoint and App Service VNet Integration
  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# Subnet for the database (no public access)
resource "azurerm_subnet" "database" {
  name                 = var.database_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  # Prevents public service endpoints in this subnet
  private_endpoint_network_policies_enabled = true
}

# NSG for the web subnet
resource "azurerm_network_security_group" "web_nsg" {
  name                = "web-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# NSG Rule: Allow traffic from Application Gateway (public-facing) to the web app
resource "azurerm_network_security_rule" "allow_app_gateway" {
  name                        = "AllowAppGateway"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80" # Standard HTTP port for the web app
  source_address_prefix       = "AzureApplicationGateway" # Service Tag
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.web_nsg.name
}

# Associate the NSG with the web subnet
resource "azurerm_subnet_network_security_group_association" "web_nsg_association" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

