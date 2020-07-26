provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags = {
    username = "Riya"
   }
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = {
    username = "Riya"
   }
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "test" {
 name                         = "publicIPForLB"
 location                     = azurerm_resource_group.main.location
 resource_group_name          = azurerm_resource_group.main.name
 allocation_method            = "Static"
 tags = {
    username = "Riya"
   }
}

resource "azurerm_network_security_group" "test" {
    name                         = "myNetworkSecurityGroup"
    location                     = azurerm_resource_group.main.location
    resource_group_name          = azurerm_resource_group.main.name
    
   
    security_rule {
        name                       = "Internet"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Deny"
        protocol                   = "*"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }


    tags = {
         username = "Riya"
    }
}

resource "azurerm_lb" "test" {
 name                = "loadBalancer"
 location            = azurerm_resource_group.main.location
 resource_group_name = azurerm_resource_group.main.name

 frontend_ip_configuration {
   name                 = "publicIPAddress"
   public_ip_address_id = azurerm_public_ip.test.id
 }

 tags = {
         username = "Riya"
    }

}

resource "azurerm_lb_backend_address_pool" "test" {
 resource_group_name = azurerm_resource_group.main.name
 loadbalancer_id     = azurerm_lb.test.id
 name                = "BackEndAddressPool"
}

resource "azurerm_network_interface" "main" {
  count               = "${var.vm_count}"
  name                = "acctni${count.index}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
         username = "Riya"
    }
}

resource "azurerm_network_interface_security_group_association" "example" {
    count                     = "${var.vm_count}"
    network_interface_id      = azurerm_network_interface.main[count.index].id
    network_security_group_id = azurerm_network_security_group.test.id
}

resource "azurerm_managed_disk" "test" {
 count                = "${var.vm_count}"
 name                 = "datadisk_existing_${count.index}"
 location             = azurerm_resource_group.main.location
 resource_group_name  = azurerm_resource_group.main.name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "10"

 tags = {
         username = "Riya"
    }

}

data "azurerm_image" "image" {
  name                = "ubuntuImage"
  resource_group_name = "udacityprojects"
}

output "image_id" {
  value = "${var.packer_image_id}"
}

resource "azurerm_availability_set" "avset" {
 name                         = "avset"
 location                     = azurerm_resource_group.main.location
 resource_group_name          = azurerm_resource_group.main.name
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
 tags = {
         username = "Riya"
    }

}

resource "azurerm_virtual_machine" "main" {
  count                           = "${var.vm_count}"
  name                            = "acctvm${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  availability_set_id             = azurerm_availability_set.avset.id
  vm_size                            = "Standard_B1s"
  network_interface_ids           = [element(azurerm_network_interface.main.*.id, count.index)]

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = "${data.azurerm_image.image.id}"
  }

  storage_os_disk {
   name              = "myosdisk${count.index}"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

 storage_data_disk {
   name              = "datadisk_new_${count.index}"
   managed_disk_type = "Standard_LRS"
   create_option     = "Empty"
   lun               = 0
   disk_size_gb      = "10"
 }

 storage_data_disk {
   name            = element(azurerm_managed_disk.test.*.name, count.index)
   managed_disk_id = element(azurerm_managed_disk.test.*.id, count.index)
   create_option   = "Attach"
   lun             = 1
   disk_size_gb    = element(azurerm_managed_disk.test.*.disk_size_gb, count.index)
 }

 os_profile {
   computer_name  = "hostname${count.index}"
   admin_username = "testadmin"
   admin_password = "Password1234!"
 }

 os_profile_linux_config {
   disable_password_authentication = false
 }

 tags = {
   username = "Riya"
 }

}
