# Configuring Proxmox for use with Terraform
1) Create a user account for Terraform 
Datacenter view -> Permissions -> Users -> Add 
For the purposes of my example, I have named the user "terraform" (peak creativity) 

2) Create a role for the terraform user
Datacenter view -> Permissions -> Roles -> Create  
Name your role something identifiable (please).  
For the purpose of my example, I have named the role "terraform-roles"  
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

3) Create a group to hold the permissions that we have created in our role  
Datacenter View -> Permissions -> Groups -> Add  
For the purpose of my example, I have left the path as / so my user can access all resources. [Objects & Paths Documentation](https://pve.proxmox.com/wiki/User_Management#Objects_and_Paths)  
Under "Role" we can select the name of our role created in step 2  
For the purpose of my example, I have named the group "terraform"  

4) Add the proxmox user to the newly created group to apply priveleges  
Datacenter View -> Permissions -> Users -> Select user -> Edit -> Groups -> select your Terraform group  

5) Create an API token for this user and save it for use in our Terraform scripts  
Datacenter View -> Permissions -> API Tokens -> Add  
Name it whatever you would like  
Copy the Token ID and Secret key that are provided. **You can not do this later. Do it now.**
