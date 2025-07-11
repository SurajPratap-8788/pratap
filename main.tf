module "resource_group" {
  source              = "../Module/azurerm_resource_group"
  resource_group_name = "ghatak_rg"
  location            = "central india"
}
module "virtual_network" {
  depends_on           = [module.resource_group]
  source               = "../Module/azurerm_virtual_network"
  virtual_network_name = "ghatak_vnet"
  location             = "central india"
  address_space        = ["10.0.0.0/16"]
  resource_group_name  = "ghatak_rg"
}
module "frontend_subnet" {
  depends_on           = [module.virtual_network, module.resource_group]
  source               = "../Module/azurerm_subnet_id"
  subnet_name          = "frontend_subnet"
  resource_group_name  = "ghatak_rg"
  virtual_network_name = "ghatak_vnet"
  address_prefixes     = ["10.0.1.0/24"]
}
module "backend_subnet" {
  depends_on           = [module.virtual_network, module.resource_group]
  source               = "../Module/azurerm_subnet_id"
  subnet_name          = "backend_subnet"
  resource_group_name  = "ghatak_rg"
  virtual_network_name = "ghatak_vnet"
  address_prefixes     = ["10.0.2.0/24"]
}
module "public_ip" {
  depends_on          = [module.resource_group]
  source              = "../Module/azurerm_public_ip"
  public_ip_name      = "ghatak_public_ip"
  resource_group_name = "ghatak_rg"
  location            = "central india"
  allocation_method   = "Static"
}
module "virtual_machine" {
    depends_on = [ module.frontend_subnet ]
    source = "../Module/azurerm_virtual_machine"
    virtual_machine_name = "frontend_vm"
    network_interface_name = "ghatak_nic"
    private_ip_address_allocation = "Dynamic"
    ip_configuration_name = "ipconfig1"
    location = "eastus"
    resource_group_name = "ghatak_rg"
    vm_size = "Standard_B1S"
    publisher = "Canonical"
    offer = "0001-com-ubuntu-server-jammy"
    sku = "22_04-lts"
    image_version = "latest"
    os_disk_name = "ghatak_os_disk"
    os_disk_caching_name = "ReadWrite"
    os_disk_create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
    os_profile_computer_name = "ghatak_vm"
    os_profile_admin_username = "vm8788"
    os_profile_admin_password = "Ghatak@1234"
    virtual_network_name = "ghatak_vnet"
    subnet_id = "/subscriptions/def6c89e-a855-4b2a-a2d3-a1bc15337302/resourceGroups/ghatak_rg/providers/Microsoft.Network/virtualNetworks/ghatak_vnet/subnets/frontend_subnet"
}

