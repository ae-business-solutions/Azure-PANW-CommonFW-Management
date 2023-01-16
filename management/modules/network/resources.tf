# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group
data "azurerm_resource_group" "MGMTRG" {
  name = var.mgmt-prefix
}