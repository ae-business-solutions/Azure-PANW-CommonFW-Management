# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "MGMTRG" {
  name = var.mgmt-prefix
}

# MGMT VNET
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network
data "azurerm_virtual_network" "mgmt" {
  name                = "mgmt-network"
  resource_group_name = data.azurerm_resource_group.MGMTRG.name
}

# Management Subnet
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet
data "azurerm_subnet" "management" {
  name                 = "mgmt-management"
  resource_group_name  = data.azurerm_resource_group.MGMTRG.name
  virtual_network_name = data.azurerm_virtual_network.mgmt.name
}