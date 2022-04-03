# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.97"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-cicd-poc-mp"
    storage_account_name = "stmitulcicdpoc"
    container_name       = "terraform-state-storage"
    key                  = "terraform.tfstate"
  }


  required_version = ">= 1.1.6"
}

locals {
  environment = terraform.workspace
  location    = "australiasoutheast"
  AppName     = "cicd-demo"
}

data "azurerm_client_config" "current" {}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }

  }
}

#module "network" {
#  source = "./modules/network"
#  resourcegroupname = var.resource_group_name
#  location = var.location
#}


resource "azurerm_resource_group" "rg_cicdpoc" {
  name     = "rg-${local.AppName}-${local.environment}"
  location = local.location
  tags = {
    "Environment" = local.environment
  }
}

resource "azurerm_app_service_plan" "cicd_appplan" {
  name                = "plan-${local.AppName}-${local.environment}"
  location            = azurerm_resource_group.rg_cicdpoc.location
  resource_group_name = azurerm_resource_group.rg_cicdpoc.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "cicd_app" {
  name                = "app-${local.AppName}-${local.environment}"
  location            = azurerm_resource_group.rg_cicdpoc.location
  resource_group_name = azurerm_resource_group.rg_cicdpoc.name
  app_service_plan_id = azurerm_app_service_plan.cicd_appplan.id

  site_config {
    use_32_bit_worker_process = true # this is only because using F1 SKU which doens't support 64bit
    windows_fx_version        = "DOTNETCORE|3.1"
  }
}

resource "azurerm_key_vault" "cicd_vault" {
  name                        = "kv-${local.AppName}-${local.environment}"
  location                    = azurerm_resource_group.rg_cicdpoc.location
  resource_group_name         = azurerm_resource_group.rg_cicdpoc.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
       "Get",
      "Set",
      "List",
      "Delete",
	"Purge"
    ]

    secret_permissions = [
      "Get",
      "Set",
      "List",
      "Delete",
	"Purge"
    ]

    storage_permissions = [
      "Get",
      "Set",
      "List",
      "Delete",
	"Purge"    ]
  }
}

resource "azurerm_key_vault_secret" "top_secret" {
  name         = "topsecret"
  value        = "Top Secret From ${azurerm_key_vault.cicd_vault.name}"
  key_vault_id = azurerm_key_vault.cicd_vault.id
}

