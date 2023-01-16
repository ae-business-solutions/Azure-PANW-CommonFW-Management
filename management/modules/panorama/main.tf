# Public IP Address: Management
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip
resource "azurerm_public_ip" "panorama-management" {
  name                = "panorama-nic-management-pip"
  location            = var.azure-region
  resource_group_name = data.azurerm_resource_group.MGMTRG.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = merge(var.default-tags)
}

# Network Interface: Management
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface
resource "azurerm_network_interface" "panorama-management" {
  name                 = "panorama-nic-management"
  location             = var.azure-region
  resource_group_name  = data.azurerm_resource_group.MGMTRG.name
  enable_ip_forwarding = false

  ip_configuration {
    name                          = "panorama-ipconfig1"
    subnet_id                     = data.azurerm_subnet.management.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.panorama-ip
    public_ip_address_id          = azurerm_public_ip.panorama-management.id
  }

  tags = merge(var.default-tags)
}

# Network Security Group: Management
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group
resource "azurerm_network_security_group" "management" {
  name                = "panorama-management-nsg"
  location            = var.azure-region
  resource_group_name = data.azurerm_resource_group.MGMTRG.name

  security_rule {
    name              = "management-inbound"
    priority          = 1000
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    #destination_port_range     = "*"
    destination_port_ranges    = ["443", "22", "3978"]
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }

  tags = merge(var.default-tags)
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association
resource "azurerm_network_interface_security_group_association" "management" {
  network_interface_id      = azurerm_network_interface.panorama-management.id
  network_security_group_id = azurerm_network_security_group.management.id
}


# We use the original azurerm_virtual_machine resource instead of the newer azurerm_linux_virtual_machine per this:
# https://github.com/hashicorp/terraform-provider-azurerm/issues/6117
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine
resource "azurerm_virtual_machine" "panorama" {
  name = "panorama"
  # Resource Group & Location:
  location            = var.azure-region
  resource_group_name = data.azurerm_resource_group.MGMTRG.name

  # Network Interfaces:
  network_interface_ids        = [azurerm_network_interface.panorama-management.id]
  primary_network_interface_id = azurerm_network_interface.panorama-management.id

  zones = ["1"]

  vm_size = "Standard_D5_v2" #(we need at least 16 vCPU and 32GB of memory for Panorama mode.)

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "paloaltonetworks"
    offer     = "panorama"
    sku       = "byol"
    version   = "10.2.3"
  }

  plan {
    publisher = "paloaltonetworks"
    name      = "byol"
    product   = "panorama"
  }

  storage_os_disk {
    name              = "panorama-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "panorama-data-disk"
    caching           = "ReadWrite"
    create_option     = "Empty"
    disk_size_gb      = "2048"
    lun               = "1"
    managed_disk_type = "Standard_LRS"
  }

  # Username and Password Authentication:
  os_profile {
    computer_name  = "panorama"
    admin_username = var.admin-user
    admin_password = var.admin-pass
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.bootstrap.primary_blob_endpoint
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  # Dependencies:
  depends_on = [
    azurerm_network_interface.panorama-management,
    azurerm_storage_account.bootstrap
  ]

  lifecycle {
    ignore_changes = all
  }
  timeouts {
    create = "60m"
    update = "60m"
  }
  tags = merge(var.default-tags)
}