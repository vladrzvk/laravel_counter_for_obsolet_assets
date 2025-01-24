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
  skip_provider_registration = true
}

# Ressources existantes
data "azurerm_resource_group" "main" {
  name = "t-clo-901-rns-0-items"
}

# Référence au DevTest Lab existant
data "azurerm_dev_test_lab" "lab" {
  name                = "t-clo-901-rns-0"
  resource_group_name = "t-clo-901-rns-0"
}

# Variables locales
locals {
  prefix = "t-clo-901-rns-0"
  tags = {
    Environment = "DevTest"
    Project     = "LaravelCounter"
    ManagedBy   = "Terraform"
  }
} 