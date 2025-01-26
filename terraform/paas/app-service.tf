# App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "${local.prefix}-plan"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
  os_type            = "Linux"
  sku_name           = "B1"

  tags = local.tags
}

# Application Key pour Laravel
resource "random_string" "app_key" {
  length  = 32
  special = true
}

# Web App
resource "azurerm_linux_web_app" "main" {
  name                = "${local.prefix}-app"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      php_version = "8.2"
    }
    always_on = true
    
    # Configuration Nginx et PHP-FPM
    app_command_line = ""  # Utilisation du serveur web intégré
    health_check_path = "/health"
  }

  app_settings = {
    # Configuration de base Laravel
    "APP_KEY"           = "base64:${base64encode(random_string.app_key.result)}"
    "APP_ENV"           = "production"
    "APP_DEBUG"         = "false"
    "APP_URL"          = "https://${local.prefix}-app.azurewebsites.net"
    
    # Configuration de la base de données
    "DB_CONNECTION"     = "mysql"
    "DB_HOST"          = azurerm_mysql_flexible_server.main.fqdn
    "DB_PORT"          = "3306"
    "DB_DATABASE"      = azurerm_mysql_flexible_database.main.name
    "DB_USERNAME"      = var.mysql_admin_username
    "DB_PASSWORD"      = var.mysql_admin_password
    
    # Configuration des logs
    "LOG_CHANNEL"      = "stack"
    "LOG_LEVEL"        = "error"
    
    # Configuration Laravel supplémentaire
    "BROADCAST_DRIVER" = "log"
    "CACHE_DRIVER"    = "file"
    "QUEUE_CONNECTION" = "sync"
    "SESSION_DRIVER"  = "file"
    "SESSION_LIFETIME" = "120"
    
    # Configuration du déploiement
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    "POST_DEPLOYMENT_SCRIPT"         = "cd /home/site/wwwroot/demo && composer install --no-dev --optimize-autoloader --no-interaction && npm ci && npm run build && php artisan config:clear && php artisan config:cache && php artisan route:clear && php artisan route:cache && php artisan view:clear && php artisan view:cache && php artisan optimize && php artisan migrate --force"
    
    # Configuration supplémentaire
    "WEBSITE_RUN_FROM_PACKAGE"      = "1"
    "COMPOSER_MEMORY_LIMIT"         = "512M"
    
    # Configuration PHP et Nginx
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "true"
    "WEBROOT"                            = "/home/site/wwwroot/demo/public"
    "PHP_OPCACHE_VALIDATE_TIMESTAMPS"    = "0"
    "PHP_OPCACHE_ENABLE"                 = "1"
    "PHP_OPCACHE_MEMORY_CONSUMPTION"     = "128"
  }

  tags = local.tags
}

# Configuration du déploiement GitHub
resource "azurerm_app_service_source_control" "github" {
  app_id                 = azurerm_linux_web_app.main.id
  repo_url              = var.github_repo_url
  branch                = "main"
  use_manual_integration = true
  use_mercurial        = false
} 