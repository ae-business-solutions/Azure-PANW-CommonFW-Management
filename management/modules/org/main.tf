#Create Azure Resource Groups

#Transit Resource Group
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group
resource "azurerm_resource_group" "MGMTRG" {
  name     = var.mgmt-prefix
  location = var.azure-region
  tags     = merge(var.default-tags)
}