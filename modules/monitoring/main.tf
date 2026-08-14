resource "azurerm_monitor_action_group" "email_alert" {
  name                = "ag-cpu-alerts"
  resource_group_name = var.resource_group_name
  short_name          = "cpualerts"

  email_receiver {
    name                    = "Alex Soto"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_metric_alert" "vm_cpu_alert" {
  name                = "alert-vm-cpu-gt-80"
  resource_group_name = var.resource_group_name
  scopes              = var.vm_ids
  target_resource_type = "Microsoft.Compute/virtualMachines"
  target_resource_location = var.location
  
  description         = "Triggers when VM CPU Percentage exceeds 80%"
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_alert.id
  }
}
