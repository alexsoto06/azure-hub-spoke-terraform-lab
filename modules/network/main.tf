variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "home_public_ip" {
  type = string
}

resource "azurerm_network_security_group" "nsg_mgmt" {
  name                = "nsg-mgmt"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-rdp-home-ip"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.home_public_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-hub-spoke-lab-traffic"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.0.0.0/16", "10.1.0.0/16"]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "deny-all-other-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "nsg_app" {
  name                = "nsg-app"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-rdp-home-ip"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.home_public_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-icmp-lab"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.0.0.0/16", "10.1.0.0/16"]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-hub-spoke-lab-traffic"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.0.0.0/16", "10.1.0.0/16"]
    destination_address_prefix = "*"
  }
}

resource "azurerm_route_table" "rt_app" {
  name                = "rt-app"
  location            = var.location
  resource_group_name = var.resource_group_name

  route {
    name           = "route-to-fake-appliance"
    address_prefix = "172.16.0.0/16"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.20"
  }
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "hub-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "mgmt_subnet" {
  name                 = "mgmt-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

  network_security_group_id = azurerm_network_security_group.nsg_mgmt.id
}

resource "azurerm_virtual_network" "spoke_vnet" {
  name                = "spoke-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = ["10.1.1.0/24"]

  network_security_group_id = azurerm_network_security_group.nsg_app.id
  route_table_id            = azurerm_route_table.rt_app.id
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

output "hub_vnet_id" {
  value = azurerm_virtual_network.hub_vnet.id
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke_vnet.id
}

output "mgmt_subnet_id" {
  value = azurerm_subnet.mgmt_subnet.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
}
