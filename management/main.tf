terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.0"
    }
  }
  cloud {
    organization = "YourTCOrganizationName"

    workspaces {
      name = "Azure-Management"
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azurerm" {
  features {}
}

module "org" {
  source       = "./modules/org"
  azure-region = var.azure-region
  default-tags = var.default-tags
  mgmt-prefix  = var.mgmt-prefix
}
module "network" {
  source                 = "./modules/network"
  azure-region           = var.azure-region
  mgmt-prefix            = var.mgmt-prefix
  default-tags           = var.default-tags
  mgmt-supernet          = var.mgmt-supernet
  mgmt-management-subnet = var.mgmt-management-subnet
  management-external    = var.management-external
  management-internal    = var.management-internal
  depends_on             = [module.org]
}

module "panorama" {
  source                 = "./modules/panorama"
  azure-region           = var.azure-region
  mgmt-prefix            = var.mgmt-prefix
  default-tags           = var.default-tags
  panorama-ip            = var.panorama-ip
  admin-pass             = var.admin-pass
  admin-user             = var.admin-user
  depends_on             = [module.network]
}

# We induce a 15 minute artificial delay as Panorama can take some time to get past the initial AutoCommit.
# https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep
resource "time_sleep" "wait_15_minutes" {
  depends_on      = [module.panorama]
  create_duration = "15m"
}

module "compute" {
  source                 = "./modules/compute"
  azure-region           = var.azure-region
  mgmt-prefix            = var.mgmt-prefix
  default-tags           = var.default-tags
  panorama-ip            = var.panorama-ip
  admin-pass             = var.admin-pass
  admin-user             = var.admin-user
  panorama-serial        = var.panorama-serial
  dgname                 = var.dgname
  tplname                = var.tplname
  transit-public-subnet  = var.transit-public-subnet
  transit-private-subnet = var.transit-private-subnet
  depends_on             = [module.panorama, time_sleep.wait_15_minutes]
}