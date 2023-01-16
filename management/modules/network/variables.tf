variable "mgmt-prefix" {
  description = "Mgmt Resource Group Prefix"
  type        = string
}
variable "azure-region" {
  description = "Azure Region"
  type        = string
}
variable "mgmt-supernet" {
  description = "Mgmt Supernet"
}
variable "mgmt-management-subnet" {
  description = "Mgmt Management Subnet"
}
variable "management-external" {
  description = "External Management IP ranges"
}
variable "management-internal" {
  description = "Internal Management IP ranges"
}
variable "default-tags" {
  description = "Default tags to apply to resources"
}