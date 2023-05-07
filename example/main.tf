module "rg" {
  source = "git::https://github.com/sknaresh2000/terraform-azurerm-resource-group.git?ref=v0.0.1"
  name   = var.resource_group_name
  tags   = module.tags.tags
}

module "tags" {
  source   = "git::https://github.com/sknaresh2000/terraform-azurerm-tags.git?ref=v0.0.1"
  app_name = var.app_name
}

module "bastion" {
  depends_on = [
    module.virtual_network
  ]
  source                = "../"
  name                  = var.bastion_name
  tags                  = module.tags.tags
  resource_group_name   = module.rg.name
  virtual_network_name  = var.vnet_name
  subnet_address_prefix = var.subnet_address_prefix
  ip_config_name        = var.ip_config_name
  pip_name              = var.pip_name
  nsg_name              = var.nsg_name
}

module "virtual_network" {
  source        = "git::https://github.com/sknaresh2000/terraform-azurerm-virtual-network.git?ref=v0.0.1"
  address_space = [var.vnet_address_prefix]
  name          = var.vnet_name
  rg_name       = module.rg.name
  tags          = module.tags.tags
}