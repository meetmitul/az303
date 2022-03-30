output "ApplicationURL" {
  value       = "https://${azurerm_app_service.cicd_app.name}.azurewebsites.net"
  description = "The URL for the App Service."
}

output "ApplicationName" {
  value       = azurerm_app_service.cicd_app.name
  description = "The Name of the App Service."
}
