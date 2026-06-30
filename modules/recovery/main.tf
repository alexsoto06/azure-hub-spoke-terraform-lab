variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = "rsv-az104"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
}
