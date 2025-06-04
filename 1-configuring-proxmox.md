# Configuring Proxmox for use with Terraform
1) Create a user account for Terraform.  
Datacenter view -> Permissions -> Users -> Add 
For the purposes of my example, I have named the user "terraform" (peak creativity) 

2) Create a role for the Terraform user.  
Datacenter view -> Permissions -> Roles -> Create  
Name your role something identifiable (please).  
For my example, I have named the role "terraform-roles"  
We need all of the following permissions in order for terraform to configure our VMs (Put on those reading glasses)  
    - Datastore.AllocateSpace
    - Datastore.Audit
    - Pool.Allocate
    - SDN.Use
    - Sys.Audit
    - Sys.Console
    - Sys.Modify
    - Sys.PowerMgmt
    - VM.Allocate
    - VM.Audit
    - VM.Clone
    - VM.Config.CDROM
    - VM.Config.CPU
    - VM.Config.Cloudinit
    - VM.Config.Disk
    - VM.Config.HWType
    - VM.Config.Memory
    - VM.Config.Network
    - VM.Config.Options
    - VM.Migrate
    - VM.Monitor
    - VM.PowerMgmt

3) Create a group to hold the permissions for our Terraform user.  
Datacenter View -> Permissions -> Groups -> Add  
For my example, I have named the group "terraform"  

4) Create the group permissions and apply the Terraform role to the group.  
Datacenter View -> Click "Permissions" -> Add -> Group Permission  
- Path: / (For my example, I have left the path as / so my user can access all resources. [Objects & Paths Documentation](https://pve.proxmox.com/wiki/User_Management#Objects_and_Paths))
- Group: terraform (name of the group created in step 3)  
- Role: terraform-roles (name of the role created in step 2)

5) Add the Terraform user to the newly configured group, this will apply the necessary group priveleges.  
Datacenter View -> Permissions -> Users -> Select user -> Edit  
For the "Groups" dropdown, select your Terraform group (name of the group created in step 2)  

6) Create an API token for this user and save it for use in our Terraform scripts.  
Datacenter View -> Permissions -> API Tokens -> Add  
Name it whatever you would like  
Copy the Token ID and Secret key that are provided. **You can not do this later. Do it now.**
