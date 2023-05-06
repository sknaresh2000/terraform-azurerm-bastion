variable "location" {
  type        = string
  description = "The Azure region to deploy Azure Services"
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to create"
  default     = "rg-bastion-module"
}

variable "app_name" {
  type        = string
  description = "Name of the application for which the resources are being created"
  default     = "bastion-module"
}

variable "vnet_address_prefix" {
  type        = string
  description = "The address prefix that will be used for the creation of VNET"
  default     = "10.0.30.0/24"
}

variable "vnet_name" {
  type        = string
  description = "Name of the VNET that will be created"
  default     = "vnet-bastion"
}

variable "subnet_address_prefix" {
  type        = string
  description = "The address prefix of the subnet that will be created"
  default     = "10.0.30.0/26"
}

variable "subnet_name" {
  type        = string
  description = "The name of the Vault subnet"
  default     = "AzureBastionSubnet"
}

variable "nsg_name" {
  type        = string
  description = "The name of the NSG that will be created"
  default     = "nsg-bastion-eus"
}

variable "ip_config_name" {
  description = "Name of IP Configuration"
  type        = string
  default     = "ipc-bastion-eus"
}

variable "pip_name" {
  description = "Name of IP"
  type        = string
  default     = "pip-bastion-eus"
}
