# Public IP Address: Management
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
resource "azurerm_public_ip" "management" {
  name                = "mgmt-nic-management-pip"
  location            = var.azure-region
  resource_group_name = data.azurerm_resource_group.MGMTRG.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(var.default-tags)
}

# Network Interface: Management
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
resource "azurerm_network_interface" "mgmt-management" {
  name                 = "mgmt-nic-management"
  location             = var.azure-region
  resource_group_name  = data.azurerm_resource_group.MGMTRG.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "mgmt-ipconfig1"
    subnet_id                     = data.azurerm_subnet.management.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.management.id
  }

  tags = merge(var.default-tags)
}

# Network Security Group: Management
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "management" {
  name                = "mgmt-management-nsg"
  location            = var.azure-region
  resource_group_name = data.azurerm_resource_group.MGMTRG.name

  security_rule {
    name                       = "management-inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "22"]
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }

  tags = merge(var.default-tags)
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association
resource "azurerm_network_interface_security_group_association" "management" {
  network_interface_id      = azurerm_network_interface.mgmt-management.id
  network_security_group_id = azurerm_network_security_group.management.id
}

# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file
data "template_file" "linux-vm-cloud-init" {
  template = file("${path.module}/startup-script.sh")
  vars = {
    PANORAMA_IP       = var.panorama-ip
    PANORAMA_PASS     = var.admin-pass
    PANORAMA_USER     = var.admin-user
    PANORAMA_SERIAL   = var.panorama-serial
    TPLNAME           = var.tplname
    DGNAME            = var.dgname
    PRIVATE_SUB       = var.transit-private-subnet
    PRIVATE_SUB_GW    = cidrhost(var.transit-private-subnet, 1)
    PUBLIC_SUB        = var.transit-public-subnet
    PUBLIC_SUB_GW     = cidrhost(var.transit-public-subnet, 1)
  }
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine
resource "azurerm_linux_virtual_machine" "mgmt" {
  name = "mgmt"
  # Resource Group & Location:
  location            = var.azure-region
  resource_group_name = data.azurerm_resource_group.MGMTRG.name

  # Network Interfaces:
  network_interface_ids = [azurerm_network_interface.mgmt-management.id]

  zone = "1"

  size = "Standard_DS3_v2"

  source_image_reference {
    publisher = "erockyenterprisesoftwarefoundationinc1653071250513"
    offer     = "rockylinux"
    sku       = "free"
    version   = "8.7.0"
  }

  plan {
    publisher = "erockyenterprisesoftwarefoundationinc1653071250513"
    name      = "free"
    product   = "rockylinux"
  }

  os_disk {
    name                 = "mgmt-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  # Username and Password Authentication:
  admin_username                  = var.admin-user
  admin_password                  = var.admin-pass
  disable_password_authentication = false

  custom_data = base64encode(data.template_file.linux-vm-cloud-init.rendered)

  # Dependencies:
  depends_on = [
    azurerm_network_interface.mgmt-management,
  ]

  tags = merge(var.default-tags)
}