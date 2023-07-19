terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.61.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

 subscription_id = "b17b0836-3476-4c4b-bae0-309aa4cf65cf"
  client_id       = "bade99d3-ad20-4016-a748-57ed2bed970b"
  client_secret   = "kfh8Q~Qn~p.IENHSHAGBhEq5qxuWb6HcMa_xqcVk"
  tenant_id       = "a73f4356-d083-474f-9cb4-5d71a8ac428c"









}



