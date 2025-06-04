terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc9"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.api_url
  pm_api_token_id     = var.token_id
  pm_api_token_secret = var.token_key
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "cloudinit-test" {
  # Proxmox configuration
  name        = "terraform-test-vm"
  desc        = "A test for using terraform and to provision cloudinit VMs"
  target_node = "pve-node-1"            # name of your Proxmox node
  clone       = "cloud-init-test-image" # name of the image to clone
  agent       = 1
  os_type     = "cloud-init"
  boot        = "order=scsi0;net0"
  memory      = 2048 # RAM in MB
  scsihw      = "virtio-scsi-single"
  cpu {
    cores   = 2 # CPU count
    sockets = 1
    type    = "host"
  }
  serial { # enable serial for display
    id = 0
  }

  disks { # gorgeous syntax
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
    scsi { # always scsi or ide
      scsi0 {
        disk {
          storage  = "local-lvm"
          size     = 32
          cache    = "writeback"
          iothread = true
          discard  = true
        }
      }
    }
  }
  network {
    id        = 0
    bridge    = "vmbr0"
    model     = "virtio"
    firewall  = false
    link_down = false
  }
  # Cloud init configuration
  ciupgrade = true
  ipconfig0  = "ip=192.168.88.65/24, gw=192.168.88.1" # Set your VM and gateway IP
  skip_ipv6  = true
  ciuser     = "test-user" 
  cipassword = "test-password"
}
