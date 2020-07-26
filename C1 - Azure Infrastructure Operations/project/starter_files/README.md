# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions
1. First we need to create a packer Image of our web server which we will be using in our terraform template. This will be an image of an Ubuntu Server.
2. The file server.json is used to create the packer image. You will need to update variables such as client_id, client_secret, subscription_id, tennat_id in this file according to your Azure account. The image will be stored in that account.
3. To make sure everything is correct in the file you can validate it with the following command, 
     packer validate server.json
4. After successfull validation, you can give the following command to build the image.
      packer build server.json
5. This takes few minutes and after that you can see the output of your successfull deployed image path in your Azure account.
6. Now when packer image is build and deployed we will next create the required infrastructure using the terraform template. All the required resources for this                project with their necessary configuration can be found in main.tf file.
7. The main.tf files requires some varibles which are mentioned in the variables.tf file. You can configure these variables according to your required when deploying the terraform template. These variables include -
    location - In which location your resources will be created.
    prefix - the prefix will be used with all the resources.
    packer_image_id - the location where your packer image is stored.
    vm_count - the no of virtual machines to create.
8. Next run terraform init to initialize terraform.
9. Then create the solution.plan file by running the command terrafrom plan
10. Next run the commad terrafrom apply to create the infrastructure.
11. After successfull creation run the command terrafrom destory to clean up all your resources.

### Output
**Your words here**

