variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "vm_size" {
  type = string
}

variable "mgmt_subnet_id" {
  type = string
}

variable "app_subnet_id" {
  type = string
}

locals {
  vm_configs = [
    {
      name       = "vm-dc1"
      subnet_id  = var.mgmt_subnet_id
      private_ip = "10.0.1.10"
      os_type    = "server2019"
    },
    {
      name       = "vm-file1"
      subnet_id  = var.mgmt_subnet_id
      private_ip = "10.0.1.20"
      os_type    = "server2019"
    },
    {
      name       = "vm-client1"
      subnet_id  = var.app_subnet_id
      private_ip = "10.1.1.10"
      os_type    = "win11"
    },
    {
      name       = "vm-app01"
      subnet_id  = var.app_subnet_id
      private_ip = "10.1.1.20"
      os_type    = "win11"
    }
  ]
}

resource "azurerm_public_ip" "pip" {
  for_each            = { for vm in local.vm_configs : vm.name => vm }
  name                = "pip-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  for_each            = { for vm in local.vm_configs : vm.name => vm }
  name                = "nic-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Static"
    private_ip_address            = each.value.private_ip
    subnet_id                     = each.value.subnet_id
    public_ip_address_id          = azurerm_public_ip.pip[each.key].id
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each            = { for vm in local.vm_configs : vm.name => vm }
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id
  ]

  os_disk {
    name                 = "osdisk-${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = each.value.os_type == "win11" ? "MicrosoftWindowsDesktop" : "MicrosoftWindowsServer"
    offer     = each.value.os_type == "win11" ? "windows-11" : "WindowsServer"
    sku       = each.value.os_type == "win11" ? "win11-24h2-pro" : "2019-datacenter"
    version   = each.value.os_type == "win11" ? "26100.8655.260607" : "latest"
  }

  enable_automatic_updates = true
}

# vm-app01 managed identity
resource "azurerm_user_assigned_identity" "vm_app01_identity" {
  name                = "id-vm-app01"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# NOTE: AzureRM doesn't support attaching user-assigned identity to azurerm_windows_virtual_machine directly
# in older versions; in newer versions you can use identity block. For simplicity, we expose principal_id.

output "vm_dc1_private_ip" {
  value = "10.0.1.10"
}

output "vm_file1_private_ip" {
  value = "10.0.1.20"
}

output "vm_client1_private_ip" {
  value = "10.1.1.10"
}

output "vm_app01_private_ip" {
  value = "10.1.1.20"
}

output "vm_app01_principal_id" {
  value = azurerm_user_assigned_identity.vm_app01_identity.principal_id
}
