output "vm_ids" {
  value       = { for k, v in azurerm_windows_virtual_machine.vm : k => v.id }
  description = "Map of VM names to VM IDs"
}
