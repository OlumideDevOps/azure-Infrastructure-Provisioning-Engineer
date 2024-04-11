# Resource Group
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "${random_pet.prefix.id}-rg"
}

# Virtual Network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "${random_pet.prefix.id}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet 1
resource "azurerm_subnet" "my_terraform_subnet_1" {
  name                 = "web-tier-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Subnet 2
resource "azurerm_subnet" "my_terraform_subnet_2" {
  name                 = "database-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "random_pet" "prefix" {
  prefix = var.resource_group_name_prefix
  length = 1
}

resource "azurerm_network_security_group" "web_nsg" {
  name                 = "web-nsg"
  location            = azurerm_virtual_network.main.location
  resource_group_name = azurerm_virtual_network.main.resource_group_name

  security_rule {
  name = "allow_http"
  priority = 100
  direction = "Inbound"
  source_address_prefix = "*"  # Allow from anywhere for now (adjust later for security)
  destination_address_prefix = azurerm_subnet.web_subnet.address_prefixes[0]  # Allow traffic to web subnet
  destination_port_range = "80"
  protocol = "Tcp"
  network_security_group_id = azurerm_network_security_group.web_nsg.id
  access = "Allow"
  }

  security_rule {
  name = "allow_https"
  priority = 101
  direction = "Inbound"
  source_address_prefix = "*"  # Allow from anywhere for now (adjust later for security)
  destination_address_prefix = azurerm_subnet.web_subnet.address_prefixes[0]  # Allow traffic to web subnet
  destination_port_range = "443"
  protocol = "Tcp"
  network_security_group_id = azurerm_network_security_group.web_nsg.id
  access = "Allow"
  }

}

resource "azurerm_network_security_group" "db_nsg" {
  name                = "db-nsg"
  location            = azurerm_virtual_network.main.location
  resource_group_name = azurerm_virtual_network.main.resource_group_name

  security_rule  {
  name = "allow_sql"
  priority = 100
  direction = "Inbound"
  source_address_prefix = azurerm_subnet.web_subnet.address_prefixes[0]  # Allow from web tier subnet only
  destination_address_prefix = azurerm_subnet.db_subnet.address_prefixes[0]  # Allow traffic to database subnet
  destination_port_range = "1433"
  protocol = "Tcp"
  network_security_group_id = azurerm_network_security_group.db_nsg.id
  access = "Allow"
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "${random_pet.prefix.id}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}