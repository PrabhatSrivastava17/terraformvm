resource "azurerm_resource_group" "rg" {
  name     = "rgprabhat"
  location = "centralindia"
}
resource "azurerm_resource_group" "rg1" {
  name     = "rgprabhat1"
  location = "centralindia"
}

resource "azurerm_storage_account" "stg" {
  name                     = "stgprabhat"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Premium"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.rg]
  name                = "ventprabhat"
  resource_group_name = "rgprabhat"
  location            = "centralindia"
  address_space       = ["10.0.0.0/16"]

}

resource "azurerm_subnet" "subnet" {
  depends_on           = [azurerm_resource_group.rg, azurerm_virtual_network.vnet]
  name                 = "subnetprabhat"
  resource_group_name  = "rgprabhat"
  virtual_network_name = "ventprabhat"
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "pip" {
  depends_on          = [azurerm_resource_group.rg]
  name                = "prabhatpip"
  resource_group_name = "rgprabhat"
  location            = "centralindia"
  allocation_method   = "Static"

}
resource "azurerm_network_interface" "nic" {
  name                = "prabhatnic"
  resource_group_name = "rgprabhat"
  location            = "centralindia"


  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = azurerm_public_ip.pip.id

 }
}
resource "azurerm_linux_virtual_machine" "vm" {
    
 name = "vmprabhat"
  depends_on = [ azurerm_network_interface.nic]
  resource_group_name    = "rgprabhat"
  location               = "centralindia"
  size =  "Standard_D2s_v5"
  admin_username = "azureuser"
  admin_password = "adminuser@123!"
  network_interface_ids = [azurerm_network_interface.nic.id]
    disable_password_authentication = false

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  

source_image_reference {
    publisher="canonical"
    offer="0001-com-ubuntu-server-jammy"
    sku="22_04-lts"
    version="latest"
}
}