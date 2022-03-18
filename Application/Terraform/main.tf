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


  required_version = ">= 1.1.7"
}

provider "azurerm" {
  features {}

  subscription_id = var.subscriptionid
}

#module "network" {
#  source = "./modules/network"
#  resourcegroupname = var.resource_group_name
#  location = var.location
#}


resource "azurerm_resource_group" "rg_cicdpoc" {
  name     = "rg-cicdpoc-${var.Environment}"
  location = var.location
}

resource "azurerm_app_service_plan" "cicd_appplan" {
  name                = "plan-cicdpoc-${var.Environment}"
  location            = azurerm_resource_group.rg_cicdpoc.location
  resource_group_name = azurerm_resource_group.rg_cicdpoc.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "cicd_app" {
  name                = "example-app-service"
  location            = azurerm_resource_group.rg_cicdpoc.location
  resource_group_name = azurerm_resource_group.rg_cicdpoc.name
  app_service_plan_id = azurerm_app_service_plan.cicd_appplan.id

  site_config {
    dotnet_framework_version = "v4.0"
  }
}
