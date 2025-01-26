output "app_service_url" {
  description = "URL de l'application web"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "mysql_server_fqdn" {
  description = "FQDN du serveur MySQL"
  value       = azurerm_mysql_flexible_server.main.fqdn
}

output "resource_group_name" {
  description = "Nom du groupe de ressources"
  value       = data.azurerm_resource_group.main.name
} 