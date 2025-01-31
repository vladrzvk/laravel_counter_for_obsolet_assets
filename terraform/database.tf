# MySQL Server
resource "azurerm_mysql_flexible_server" "main" {
  name                = "laravel-app-mysql"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  administrator_login    = var.db_username
  administrator_password = var.db_password

  sku_name = "B_Standard_B1s"  # Le plus petit/moins cher
  version  = "8.0.21"

  storage {
    size_gb = 20
  }
}

# Base de données Laravel
resource "azurerm_mysql_flexible_database" "main" {
  name                = "laravel"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8mb4"
  collation          = "utf8mb4_unicode_ci"
}

# Règle de firewall pour permettre l'accès depuis Azure
resource "azurerm_mysql_flexible_server_firewall_rule" "azure" {
  name                = "allow-azure-services"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
} 