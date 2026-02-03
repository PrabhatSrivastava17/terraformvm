terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.58.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "9ae44b4d-7967-4561-84e0-066ac02817fd"
}