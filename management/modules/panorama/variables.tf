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
variable "admin-user" {
  description = "Initial Panorama Admin User"
}
variable "admin-pass" {
  description = "Initial Panorama Admin Password"
}
variable "panorama-ip" {
  description = "Panorama IP"
  type        = string
}