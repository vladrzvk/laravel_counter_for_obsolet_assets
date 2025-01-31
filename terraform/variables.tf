variable "location" {
  description = "La région Azure où déployer les ressources"
  type        = string
  default     = "northeurope"
}

variable "environment" {
  description = "Environnement (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "db_username" {
  description = "Nom d'utilisateur pour MySQL"
  type        = string
  default     = "adminuser"
}

variable "db_password" {
  description = "Mot de passe pour MySQL"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd123!"  # À changer en production !
}

variable "github_repo_url" {
  description = "URL du dépôt GitHub contenant l'application Laravel"
  type        = string
  default     = "https://github.com/vladrzvk/laravel_counter_for_obsolet_assets"
} 