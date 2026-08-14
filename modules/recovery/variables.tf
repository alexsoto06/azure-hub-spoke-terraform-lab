variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "vm_ids" {
  type        = map(string)
  description = "Map of VM names to VM resource IDs"
  default     = {}
}
