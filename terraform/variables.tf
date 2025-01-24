variable "location" {
  description = "La région Azure où déployer les ressources"
  type        = string
  default     = "westeurope"
}

variable "environment" {
  description = "Environnement (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "mysql_admin_username" {
  description = "Nom d'utilisateur administrateur pour MySQL"
  type        = string
}

variable "mysql_admin_password" {
  description = "Mot de passe administrateur pour MySQL"
  type        = string
  sensitive   = true
}

variable "app_service_sku" {
  description = "The SKU for App Service Plan"
  type        = string
  default     = "B1"  # Basic tier, ajustable selon les besoins
}

variable "project" {
  description = "Nom du projet"
  type        = string
  default     = "laravel-counter"
}

variable "github_repo_url" {
  description = "URL du dépôt GitHub contenant l'application Laravel"
  type        = string
} 