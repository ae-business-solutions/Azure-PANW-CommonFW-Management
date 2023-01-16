output "azure-region" {
  description = "Azure Region"
  value       = var.azure-region
}
output "mgmt-prefix" {
  description = "Mgmt Resource Group prefix"
  value       = var.mgmt-prefix
}
output "default-tags" {
  description = "Default tags to apply to resources"
  value       = var.default-tags
}
output "mgmt-supernet" {
  description = "Mgmt Supernet"
  value       = var.mgmt-supernet
}
output "mgmt-management-subnet" {
  description = "Mgmt Management Subnet"
  value       = var.mgmt-management-subnet
}
output "transit-public-subnet" {
  description = "Transit Public Subnet"
  value       = var.transit-public-subnet
}
output "transit-private-subnet" {
  description = "Transit Private Subnet"
  value       = var.transit-private-subnet
}
output "management-external" {
  description = "External Management IP ranges"
  value       = var.management-external
}
output "management-internal" {
  description = "Internal Management IP ranges"
  value       = var.management-internal
}
output "admin-user" {
  description = "Initial Panorama Admin User"
  value       = var.admin-user
}
output "panorama-serial" {
  description = "Panorama Serial Number"
  value       = var.panorama-serial
}
output "panorama-ip" {
  description = "panorama-ip"
  value       = var.panorama-ip
}
output "dgname" {
  description = "Device Group Name"
  value       = var.dgname
}
output "tplname" {
  description = "Template Name"
  value       = var.tplname
}