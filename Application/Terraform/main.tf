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
    location = "australiasoutheast"
    AppName = "cicd-demo"
}

provider "azurerm" {
  features {}
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
    dotnet_framework_version = "v4.0"
    use_32_bit_worker_process = true
  }
}
