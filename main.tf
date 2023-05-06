resource "azurerm_subnet" "bastion-subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.subnet_address_prefix]
}


resource "azurerm_public_ip" "bastion-pip" {
  name                = var.pip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  sku                 = var.public_ip_sku
  zones               = var.pip_zones
  tags                = var.tags
}

resource "azurerm_bastion_host" "bastion" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.bastion_sku
  copy_paste_enabled  = var.copy_paste_enabled
  file_copy_enabled   = var.file_copy_enabled
  ip_connect_enabled  = var.ip_connect_enabled
  scale_units         = var.scale_units
  tunneling_enabled   = var.tunneling_enabled
  tags                = var.tags

  ip_configuration {
    name                 = var.ip_config_name
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion-pip.id
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "nsg-rule" {
  for_each                                   = local.nsgrules
  name                                       = each.key
  direction                                  = local.nsgrules[each.key].direction
  access                                     = local.nsgrules[each.key].access
  priority                                   = local.nsgrules[each.key].priority
  protocol                                   = local.nsgrules[each.key].protocol
  source_port_range                          = local.nsgrules[each.key].source_port_range
  destination_port_range                     = local.nsgrules[each.key].destination_port_range
  source_port_ranges                         = local.nsgrules[each.key].source_port_ranges
  destination_port_ranges                    = local.nsgrules[each.key].destination_port_ranges
  source_address_prefix                      = local.nsgrules[each.key].source_address_prefix
  source_address_prefixes                    = local.nsgrules[each.key].source_address_prefixes
  destination_address_prefix                 = local.nsgrules[each.key].destination_address_prefix
  destination_address_prefixes               = local.nsgrules[each.key].destination_address_prefixes
  source_application_security_group_ids      = local.nsgrules[each.key].source_asg_ids
  destination_application_security_group_ids = local.nsgrules[each.key].destination_asg_ids
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  depends_on = [
    azurerm_network_security_rule.nsg-rule
  ]
  subnet_id                 = var.bastion_subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

locals {
  nsgrules = {
    AllowInternet = {
      priority                     = 200
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_range       = "443"
      source_address_prefix        = "Internet"
      destination_address_prefix   = "*"
      source_port_ranges           = null
      destination_port_ranges      = null
      source_address_prefixes      = null
      destination_address_prefixes = null
      source_asg_ids               = null
      destination_asg_ids          = null
    }
    AllowGM = {
      priority                     = 210
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_range       = "443"
      source_address_prefix        = "GatewayManager"
      destination_address_prefix   = "*"
      source_port_ranges           = null
      destination_port_ranges      = null
      source_address_prefixes      = null
      destination_address_prefixes = null
      source_asg_ids               = null
      destination_asg_ids          = null
    }
    AllowBastionHostCommunication = {
      priority                     = 220
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      destination_port_ranges      = ["8080", "5701"]
      source_address_prefix        = "VirtualNetwork"
      destination_address_prefix   = "VirtualNetwork"
      source_port_ranges           = null
      destination_port_range       = null
      source_address_prefixes      = null
      destination_address_prefixes = null
      source_asg_ids               = null
      destination_asg_ids          = null
    }
    AllowLoadBalancer = {
      priority                     = 230
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_ranges      = null
      source_address_prefix        = "AzureLoadBalancer"
      destination_address_prefix   = "*"
      source_port_ranges           = null
      destination_port_range       = 443
      source_address_prefixes      = null
      destination_address_prefixes = null
      source_asg_ids               = null
      destination_asg_ids          = null
    }
    DenyAll-In = {
      priority                     = 4096
      direction                    = "Inbound"
      access                       = "Deny"
      protocol                     = "*"
      source_port_range            = "*"
      destination_port_range       = "*"
      source_address_prefix        = "*"
      destination_address_prefix   = "*"
      source_port_ranges           = null
      destination_port_ranges      = null
      source_address_prefixes      = null
      destination_address_prefixes = null
      source_asg_ids               = null
      destination_asg_ids          = null
    }
    AllowRDPSSH = {
      priority                     = 200
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      source_port_ranges           = null
      destination_port_range       = null
      destination_port_ranges      = ["3389", "22"]
      source_address_prefix        = "*"
      destination_address_prefix   = "VirtualNetwork"
      source_address_prefixes      = null
      destination_address_prefixes = null
      source_asg_ids               = null
      destination_asg_ids          = null
    }
    AllowAzureCloud = {
      priority                     = 210
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_range       = "443"
      source_address_prefix        = "*"
      destination_address_prefix   = "AzureCloud"
      source_port_ranges           = null
      destination_port_ranges      = null
      source_address_prefixes      = null
      destination_address_prefixes = null
      source_asg_ids               = null
      destination_asg_ids          = null
    }
    AllowBastionCommunication = {
      priority                     = 220
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      destination_port_ranges      = ["8080", "5701"]
      source_address_prefix        = "VirtualNetwork"
      destination_address_prefix   = "VirtualNetwork"
      source_port_ranges           = null
      destination_port_range       = null
      source_address_prefixes      = null
      destination_address_prefixes = null
      source_asg_ids               = null
      destination_asg_ids          = null
    }
    AllowSessionInformation = {
      priority                     = 230
      direction                    = "Outbound"
      access                       = "Allow"
      protocol                     = "*"
      source_port_range            = "*"
      destination_port_ranges      = null
      source_address_prefix        = "*"
      destination_address_prefix   = "Internet"
      source_port_ranges           = null
      destination_port_range       = 80
      source_address_prefixes      = null
      destination_address_prefixes = null
      source_asg_ids               = null
      destination_asg_ids          = null
    }
    DenyAll-Out = {
      priority                     = 4096
      direction                    = "Outbound"
      access                       = "Deny"
      protocol                     = "*"
      source_port_range            = "*"
      destination_port_range       = "*"
      source_address_prefix        = "*"
      destination_address_prefix   = "*"
      source_port_ranges           = null
      destination_port_ranges      = null
      source_address_prefixes      = null
      destination_address_prefixes = null
      source_asg_ids               = null
      destination_asg_ids          = null
    }
  }
}