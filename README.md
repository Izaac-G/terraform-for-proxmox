# Provisioning Proxmox VMs from cloud-init images using Terraform
My notes on how to create Proxmox VMs using cloud-init images and the Telmate Terraform provider.

## Components

### main.tf
This is our main terraform configuration file. Examples can be found [here](https://github.com/Telmate/terraform-provider-proxmox/tree/master/examples)

### variables.tf
A variables.tf fileis needed to declare the data type for each variable we intend to pass to main.tf. Terraform will prompt us for these values in the "Plan" and "Apply" phase, as well as validate that the type matches our definition in variables.tf.  
By setting "sensitive" to true, any values we pass through our defined variables will not be exposed in our CLI output.

### secrets.tfvars
A .tfvars file allows us to assign values to the variables we have created in variables.tf, we will be using our .tfvars file to store our Proxmox API URL, token ID, and token key.  
We will need to pass our values to Terraform during the "Plan" and "Apply" phases, this can be done by adding the flag `-var-file="secrets.tfvars"` to the end of our plan & apply commands.

### .terraformignore
This file will exclude our markdown from being parsed by Terraform.  
Following .gitignore syntax, we can ignore all .md files.
