variable "resource_group_name" {
  type = string
}

variable "vm_ids" {
  type        = list(string)
  description = "List of VM resource IDs to monitor"
}

variable "alert_email" {
  type        = string
  description = "Email address for CPU alerts"
  default     = "alex.soto@lockmannkrane.com"
}
