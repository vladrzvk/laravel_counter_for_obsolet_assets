terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Groupe de ressources
resource "azurerm_resource_group" "main" {
  name     = "laravel-app-rg"
  location = "northeurope"
}

# Container Registry
resource "azurerm_container_registry" "main" {
  name                = "laravelappregistry"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Environment Container Apps
resource "azurerm_container_app_environment" "main" {
  name                       = "laravel-app-env"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
}

# Container App
resource "azurerm_container_app" "main" {
  name                         = "laravel-app"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name         = azurerm_resource_group.main.name
  revision_mode               = "Single"

  template {
    container {
      name   = "laravel-app"
      image  = "${azurerm_container_registry.main.login_server}/laravel-app:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "APP_KEY"
        value = var.app_key
      }
      env {
        name  = "APP_ENV"
        value = "production"
      }
      env {
        name  = "DB_CONNECTION"
        value = "mysql"
      }
      env {
        name  = "DB_HOST"
        value = azurerm_mysql_flexible_server.main.fqdn
      }
      env {
        name  = "DB_DATABASE"
        value = azurerm_mysql_flexible_database.main.name
      }
      env {
        name  = "DB_USERNAME"
        value = var.db_username
      }
      env {
        name  = "DB_PASSWORD"
        value = var.db_password
      }
    }
  }

  ingress {
    external_enabled = true
    target_port     = 80
    transport       = "auto"
  }
}

# Plan App Service
resource "azurerm_service_plan" "main" {
  name                = "laravel-app-plan"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type            = "Linux"
  sku_name           = "B1"
}

# Web App
resource "azurerm_linux_web_app" "main" {
  name                = "laravel-app-webapp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      php_version = "8.2"
    }
    always_on = true
  }

  app_settings = {
    "APP_KEY"           = "base64:${base64encode(random_string.app_key.result)}"
    "APP_ENV"           = "production"
    "APP_DEBUG"         = "true"
    
    # Base de données
    "DB_CONNECTION"     = "mysql"
    "DB_HOST"          = azurerm_mysql_flexible_server.main.fqdn
    "DB_PORT"          = "3306"
    "DB_DATABASE"      = azurerm_mysql_flexible_database.main.name
    "DB_USERNAME"      = var.db_username
    "DB_PASSWORD"      = var.db_password

    # Configuration PHP
    "PHP_MEMORY_LIMIT" = "128M"
  }
}

# Génération de la clé d'application Laravel
resource "random_string" "app_key" {
  length  = 32
  special = true
} 