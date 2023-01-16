variable "mgmt-prefix" {
  description = "Mgmt Resource Group Prefix"
  type        = string
}
variable "azure-region" {
  description = "Azure Region"
  type        = string
}
variable "default-tags" {
  description = "Default tags to apply to resources"
}
variable "mgmt-supernet" {
  description = "Mgmt Supernet"
}
variable "mgmt-management-subnet" {
  description = "Mgmt Management Subnet"
}
variable "transit-public-subnet" {
  description = "Transit Public Subnet"
}
variable "transit-private-subnet" {
  description = "Transit Private Subnet"
}
variable "management-external" {
  description = "External Management IP ranges"
}
variable "management-internal" {
  description = "Internal Management IP ranges"
}
variable "admin-user" {
  description = "Initial Panorama Admin User"
}
variable "admin-pass" {
  description = "Initial Panorama Admin Password"
}
variable "panorama-serial" {
  description = "Panorama Serial Number"
  type        = string
}
variable "panorama-ip" {
  description = "Panorama IP"
  type        = string
}
variable "dgname" {
  description = "Device Group Name"
  type        = string
}
variable "tplname" {
  description = "Template Name"
  type        = string
}