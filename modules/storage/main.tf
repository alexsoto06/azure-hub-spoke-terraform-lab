variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  allow_blob_public_access  = false
}

resource "azurerm_storage_container" "backups" {
  name                  = "blob-backups"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "shared" {
  name                 = "fs-shared"
  storage_account_name = azurerm_storage_account.sa.name
  quota                = 100
}

output "storage_account_id" {
  value = azurerm_storage_account.sa.id
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}
