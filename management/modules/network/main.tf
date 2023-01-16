#VNETs

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "mgmt-management-NSG" {
  name                = "mgmt-management-security-group"
  location            = data.azurerm_resource_group.MGMTRG.location
  resource_group_name = data.azurerm_resource_group.MGMTRG.name

  #Inbound Security Rules
  security_rule {
    name                       = "AllowPublicManagement"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "443"]
    source_address_prefixes    = var.management-external
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowManagement"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = var.management-internal
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 1500
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = merge(var.default-tags)
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network
resource "azurerm_virtual_network" "mgmt" {
  name                = "mgmt-network"
  location            = data.azurerm_resource_group.MGMTRG.location
  resource_group_name = data.azurerm_resource_group.MGMTRG.name
  address_space       = var.mgmt-supernet

  tags = merge(var.default-tags)
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet
resource "azurerm_subnet" "mgmt-management" {
  name                 = "mgmt-management"
  resource_group_name = data.azurerm_resource_group.MGMTRG.name
  virtual_network_name = azurerm_virtual_network.mgmt.name
  address_prefixes     = [var.mgmt-management-subnet]
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association
resource "azurerm_subnet_network_security_group_association" "transit-management" {
  subnet_id                 = azurerm_subnet.mgmt-management.id
  network_security_group_id = azurerm_network_security_group.mgmt-management-NSG.id
}