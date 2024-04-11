# Associate Network Interface to the Backend Pool of the Load Balancer
resource "azurerm_network_interface_backend_address_pool_association" "my_nic_lb_pool" {
  count                   = 2
  network_interface_id    = azurerm_network_interface.my_terraform_nic_nic[count.index].id
  ip_configuration_name   = "ipconfig${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.my_lb_pool.id
}

# Create Public Load Balancer
resource "azurerm_lb" "my_lb" {
  name                = var.load_balancer_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = var.public_ip_name
    subnet_id            = azurerm_subnet.my_terraform_subnet_1.id
    public_ip_address_id = azurerm_public_ip.my_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "my_lb_pool" {
  loadbalancer_id      = azurerm_lb.my_lb.id
  name                 = "test-pool"
}

resource "azurerm_network_interface_backend_address_pool_association" "my_lb_pool" {
count = 3
network_interface_id = azurerm_network_interface.my_terraform_nic.id
ip_configuration_name = azurerm_network_interface.my_terraform_azurem_network
backend_address_pool_id = azurerm_lb_backend_address_pool.my_lb_pool.id
}

resource "azurerm_lb_probe" "my_lb_probe" {
  //resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.my_lb.id
  name                = "test-probe"
  port                = 80
  protocol            = "HTTP"
}

resource "azurerm_lb_rule" "my_lb_rule" {
 // resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.my_lb.id
  name                           = "test-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  disable_outbound_snat          = true
  frontend_ip_configuration_name = var.public_ip_name
  probe_id                       = azurerm_lb_probe.my_lb_probe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.my_lb_pool.id]
}

resource "azurerm_lb_outbound_rule" "my_lboutbound_rule" {
  //resource_group_name     = azurerm_resource_group.rg.name
  name                    = "test-outbound"
  loadbalancer_id         = azurerm_lb.my_lb.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.my_lb_pool.id

  frontend_ip_configuration {
    name = var.public_ip_name
  }
}