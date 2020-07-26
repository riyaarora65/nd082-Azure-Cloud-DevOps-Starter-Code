variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default = "udacity"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "East US"
}

variable "packer_image_id" {
    description = "The image id for the packer custom image"
    default = "/subscriptions/d7740e29-7b87-4f2a-b978-193bae5e2bcb/resourceGroups/udacityprojects/providers/Microsoft.Compute/images/ubuntuImage"
}

variable "vm_count" {
  description = "The no of VMs we want in our infra"
  default = "2"
}