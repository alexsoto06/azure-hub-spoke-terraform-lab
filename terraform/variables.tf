variable "resource_group_name" {
  description = "Existing resource group name (e.g., ADS_Test_RG)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "admin_username" {
  description = "Admin username for Windows VMs"
  type        = string
  default     = "alexsoto"
}

variable "admin_password" {
  description = "Admin password for Windows VMs"
  type        = string
  sensitive   = true
}

variable "home_public_ip" {
  description = "Home public IP in CIDR format"
  type        = string
  default     = "71.201.33.162/32"
}

variable "vm_size" {
  description = "VM size for lab VMs"
  type        = string
  default     = "Standard_B1s"
}

variable "storage_account_name" {
  description = "Globally unique storage account name"
  type        = string
  default     = "stalexsoto104"
}
