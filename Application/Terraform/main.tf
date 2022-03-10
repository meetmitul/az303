# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.97"
    }
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


resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}