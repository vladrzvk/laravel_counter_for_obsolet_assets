# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "main" {
  name                = "${local.prefix}-mysql"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name

  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password

  sku_name = "B_Standard_B1ms"
  version  = "8.0.21"

  storage {
    size_gb = 20
  }

  zone = "1"

  tags = local.tags
}

# Base de données Laravel
resource "azurerm_mysql_flexible_database" "main" {
  name                = "laravel"
  resource_group_name = data.azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  charset             = "utf8"
  collation          = "utf8_unicode_ci"
}

# Règle de firewall pour permettre l'accès depuis Azure
resource "azurerm_mysql_flexible_server_firewall_rule" "azure" {
  name                = "allow-azure-services"
  resource_group_name = data.azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
} 