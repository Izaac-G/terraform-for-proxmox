# Creating a Proxmox VM template using cloud-init

1) Create a blank VM (GUI Method)  
**Remember the VM ID, this is what we want to use when referencing the created image in the terminal**
No disk image is needed  
When you get to "System", check Qemu Agent on. (This is also done in our Terraform config so I need to test if this is necessary)  
No disk needed (remove disk when configuring VM as there will already be one by default)  
Use low resources (the VMs created from this template will have resources configured in Terraform)  
Once VM is created, we'll mount a cloud init drive  
VM -> Hardware -> Add -> CloudInit Drive   
- If you have not configured any other storage devices in Proxmox, your storage is most likely named "local-lvm". local-lvm is the default if you used LVM during your Proxmox installation

2) Find the link of the most recent stable cloud image then snag the .img link (qcow2 should work too, QEMU converts between image formats so I'm pretty sure it matters nil)  
    - [Ubuntu 24.04](https://cloud-images.ubuntu.com/minimal/releases/noble/release/)
    - [Debian 12 LTS (Bookworm)](https://cloud.debian.org/images/cloud/bookworm/latest/)
    - [Centos 9 stream (be sure to choose a generic cloud image and not a container!)](https://cloud.centos.org/centos/9-stream/s390x/images/)
    - [Arch (It's actually less fun to install this way)](https://gitlab.archlinux.org/archlinux/arch-boxes/-/packages/)

3) SSH into your proxmox host as root

4) Install libguestfs-tools if your Proxmox host does not have it, we will need this to install the QEMU-guest-agent on our virtual machine disk image.  
`apt-get install libguestfs-tools`

4) Download your desired cloud init image  
`wget {your image link from step 2}`

5) Install the QEMU Guest Agent on your cloud-init image (this step can be skipped if the cloud-init image has QEMU Guest Agent installed. Ubuntu does not have the agent already.). virt-customize sets the machine-id; for our purposes this is undesired behavior, we will truncate /etc/machine-id so that VMs created from this template do not all share the same machine-id.  
`virt-customize -a {image name} --install qemu-guest-agent --truncate /etc/machine-id`

6) Rename the image to .qcow2 (I have not verified that this is necessary when donwloading a .qcow2)  
`mv {installed image} {new image name}.qcow2`

7) Resize the image  
`qemu-img resize {new image name}.qcow2 {size}`

8) Enable display for the VM (The GUI usually does this for you, but we aren't using the GUI. Since we also have serial display set in our Terraform config, I'll need to test if this is necessary.)  
`qm set {VM ID from step 1} --serial0 socket --vga serial0`

9) Import the newly created disk into Proxmox  
`qm importdisk {VM ID from step 1} {new image name} {local storage device}`  
- If you have not configured any other storage devices in Proxmox, your storage is most likely"local-lvm". local-lvm is the default if you use LVM during your Proxmox installation

10) Configure the template VM to use the newly created disk on the GUI  
VM -> Hardware -> Click that newly created disk -> Edit  
- If you are using an SSD 
    - Turn on the [Discard](https://www.oreilly.com/library/view/mastering-proxmox/9781788397605/03431488-8696-41e3-92e2-a60482b6e4e9.xhtml) option.
    - Also turn on the SSD emulation (what were you planning to emulate with this? A hard drive? A floppy? Get with the times.)  
    Select Advanced -> SSD Emulation

11) Convert your VM to a template (Not a bad idea to take a backup before proceeding, as any modifications after this will require you to create a new VM)  
Right click the VM -> convert to template
