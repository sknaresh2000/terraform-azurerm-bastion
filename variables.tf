variable "resource_group_name" {
  description = "Name of the resource group to deploy Azure Bastion"
  type        = string
}

variable "bastion_name" {
  description = "Name of Azure Bastion"
  type        = string
}

variable "subnet_address_prefix" {
  description = "Subnet address prefix for Azure Bastion"
  type        = string
}

variable "tags" {
  description = "Tags required to be setup on Azure Bastion"
  type        = map(string)
}

variable "virtual_network_name" {
  description = "Name of the Virtual Network to create AzureBastionSubnet"
  type        = string
}

variable "location" {
  description = "Location where Azure Bastion will be deployed"
  type        = string
  default     = "eastus"
}

variable "public_ip_sku" {
  description = "Public IP sku"
  type        = string
  default     = "Standard"
}

variable "allocation_method" {
  description = "Allocation method of IP address"
  type        = string
  default     = "Static"
}

variable "ip_config_name" {
  description = "Name of IP Configuration"
  type        = string
}

variable "pip_name" {
  description = "Name of IP"
  type        = string
}

variable "nsg_name" {
  description = "Name of Network Security Group"
  type        = string
}

variable "bastion_subnet_id" {
  description = "id of the subnet to deploy AzureBastion"
  type        = string
}

variable "copy_paste_enabled" {
  description = "Is Copy/Paste feature enabled for the Bastion Host. Defaults to true"
  type        = string
  default     = true
}

variable "file_copy_enabled" {
  description = "Is File Copy feature enabled for the Bastion Host. Defaults to false"
  type        = string
  default     = false
}

variable "ip_connect_enabled" {
  description = "Is IP Connect feature enabled for the Bastion Host. Defaults to false"
  type        = string
  default     = false
}

variable "scale_units" {
  description = "The number of scale units with which to provision the Bastion Host. Possible values are between 2 and 50. Defaults to 2"
  type        = number
  default     = 2
}

variable "bastion_sku" {
  description = "The SKU of the Bastion Host. Accepted values are Basic and Standard. Defaults to Basic"
  type        = string
  default     = "Basic"
}

variable "pip_zones" {
  description = "A collection containing the availability zone to allocate the Public IP in."
  default     = []
}

variable "tunneling_enabled" {
  description = "Is Tunneling feature enabled for the Bastion Host. Defaults to false"
  type        = bool
  default     = false
}