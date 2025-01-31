# Configuration du déploiement depuis GitHub
resource "azurerm_app_service_source_control" "github" {
  app_id   = azurerm_linux_web_app.app.id
  repo_url = "https://github.com/vladrzvk/laravel_counter_for_obsolet_assets"
  branch   = "main"
  use_manual_integration = false

  github_action_configuration {
    generate_workflow_file = true
    code_configuration {
      runtime_stack   = "php"
      runtime_version = "8.2"
    }
  }
} 