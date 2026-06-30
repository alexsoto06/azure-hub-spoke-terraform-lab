variable "storage_account_id" {
  type = string
}

variable "app01_principal_id" {
  type = string
}

locals {
  storage_blob_data_reader_role_id = "2a2b9908-6ea1-4ae2-8e65-a410df84e7d1"
}

resource "azurerm_role_assignment" "app01_blob_reader" {
  scope                = var.storage_account_id
  role_definition_id   = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/${local.storage_blob_data_reader_role_id}"
  principal_id         = var.app01_principal_id
}

data "azurerm_client_config" "current" {}
