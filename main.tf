



resource "azurerm_resource_group" "example" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  address_space       = [var.vnet_addressspace]
  location            = var.location
  resource_group_name = var.rg_name
  depends_on          = [azurerm_resource_group.example]
}

resource "azurerm_subnet" "example" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_prefix]
  depends_on           = [azurerm_resource_group.example, azurerm_virtual_network.example]
}

resource "azurerm_network_interface" "example" {
  count               = var.numberofvms
  name                = "${var.nicname}${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  depends_on          = [azurerm_resource_group.example]

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  count               = var.numberofvms
  name                = "${var.vmname}-${count.index}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example[count.index].id,
  ]
  admin_password                  = "Dkwnh@1234!"
  disable_password_authentication = "false"




  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}


resource "azurerm_public_ip" "example" {
  count               = var.numberofvms
  name                = "publicipforvm-${count.index}"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
  depends_on          = [azurerm_resource_group.example]


}





resource "azurerm_network_security_group" "example" {
  name                = "acceptanceTestSecurityGroup1"
  location            = var.location
  resource_group_name = var.rg_name
  depends_on          = [azurerm_resource_group.example]

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"


  }

  security_rule {
    name                       = "test1234"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"


  }



}

resource "azurerm_network_interface_security_group_association" "example" {
  count = var.numberofvms
  network_interface_id      = azurerm_network_interface.example[count.index].id
  

  network_security_group_id = azurerm_network_security_group.example.id

}




