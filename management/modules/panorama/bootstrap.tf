# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
resource "random_string" "storage_account_name" {
  length  = 5
  lower   = true
  upper   = false
  special = false
  numeric = false
}

# Storage Account:  Panorama Bootstrap
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
resource "azurerm_storage_account" "bootstrap" {
  name                      = "bootstrap${random_string.storage_account_name.result}"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  location                  = var.azure-region
  resource_group_name       = data.azurerm_resource_group.MGMTRG.name
  depends_on                = [data.azurerm_resource_group.MGMTRG]
  enable_https_traffic_only = true

  tags = merge(var.default-tags)
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share
resource "azurerm_storage_share" "bootstrap" {
  name                 = "bootstrap"
  storage_account_name = azurerm_storage_account.bootstrap.name
  quota                = 2
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share_directory
resource "azurerm_storage_share_directory" "panorama" {
  name                 = "panorama"
  share_name           = azurerm_storage_share.bootstrap.name
  storage_account_name = azurerm_storage_account.bootstrap.name
}