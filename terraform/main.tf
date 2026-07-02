terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }
}

provider "azurerm" {
  features {}
  
resource_provider_registrations = "none"
}

# -------------------------------------------------------------------
# VARIABLES & TFVARS ARE IN variables.tf / terraform.tfvars
# -------------------------------------------------------------------

# Resource group is assumed to already exist: ADS_Test_RG
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# ---------------------- NETWORK MODULE -----------------------------

module "network" {
  source              = "../modules/network"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  home_public_ip      = var.home_public_ip
}

# ---------------------- COMPUTE MODULE -----------------------------

module "compute" {
  source              = "../modules/compute"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  vm_size             = var.vm_size
  mgmt_subnet_id      = module.network.mgmt_subnet_id
  app_subnet_id       = module.network.app_subnet_id
}

# ---------------------- STORAGE MODULE -----------------------------

module "storage" {
  source              = "../modules/storage"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  storage_account_name = var.storage_account_name
}

# ---------------------- IDENTITY MODULE ----------------------------

module "identity" {
  source               = "../modules/identity"
  storage_account_id   = module.storage.storage_account_id
  app01_principal_id   = module.compute.vm_app01_principal_id
}

# ---------------------- RECOVERY MODULE ----------------------------

module "recovery" {
  source              = "../modules/recovery"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

# ---------------------- OUTPUTS -----------------------------------

output "vm_dc1_private_ip" {
  value = module.compute.vm_dc1_private_ip
}

output "vm_file1_private_ip" {
  value = module.compute.vm_file1_private_ip
}

output "vm_client1_private_ip" {
  value = module.compute.vm_client1_private_ip
}

output "vm_app01_private_ip" {
  value = module.compute.vm_app01_private_ip
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}
