# Data source: Resource group
data "azurerm_resource_group" "tclo" {
  name = var.resource_group_name
}

# Data source: DevTest Lab
data "azurerm_dev_test_lab" "tclo" {
  name                = var.devtestlab_name
  resource_group_name = data.azurerm_resource_group.tclo.name
}


# Create VM
resource "azurerm_dev_test_linux_virtual_machine" "vmapp" {
  # count                  = var.instance_count
  # name  = "deplinux-test-${count.index}" 
  name                   = "deplinux-test"
  lab_name               = data.azurerm_dev_test_lab.tclo.name
  resource_group_name    = data.azurerm_resource_group.tclo.name
  location               = var.location
  size                   = "Standard_A4_v2"
  username               = var.username_app
  password               = var.password_app
  ssh_key                = file("./ssh/id_terraform.pub")
  # ssh_key                = local.public_key_openssh
  lab_virtual_network_id = var.lab_virtual_network_id
  lab_subnet_name        = var.lab_subnet_name
  storage_type           = "Standard"
  notes                  = "TCLO TERRAFORM VMs"
  allow_claim            = false

  gallery_image_reference {
    offer     = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    environment = "development"
  }
}

locals {

  # Récupère la FQDN générée par la VM d'azure
  fqdn = azurerm_dev_test_linux_virtual_machine.vmapp.fqdn

  # Fusionne la map existante var.docker_env_vars avec la nouvelle clé "AZ_FQDN"
  docker_env_vars_merged = merge(
    var.docker_env_vars,
    { "AZ_FQDN" = local.fqdn }
  )
  docker_env_vars_json = jsonencode({
    docker_env_vars = local.docker_env_vars_merged
  })

}

# Install Python and Ansible
resource "null_resource" "setup_ansible" {
  provisioner "remote-exec" {
    inline = [
    # Activer le mode strict et exporter la variable pour un mode non-interactif
      "set -eux",
      "export DEBIAN_FRONTEND=noninteractive",
      "echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections",
 
      # Attendre la libération du verrou dpkg s'il y en a un
      "while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do echo 'Waiting for dpkg lock release...'; sleep 2; done",
 
      # Installer needrestart et configurer le redémarrage automatique silencieux
      "sudo apt-get update -y",
      "sudo apt-get install -y needrestart",
      "sudo sed -i 's/^#\\$nrconf{restart} = .*/\\$nrconf{restart} = \"a\";/' /etc/needrestart/needrestart.conf",
 
      # Configuration temporaire pour apt pour éviter les redémarrages interactifs
      "sudo mkdir -p /etc/apt/apt.conf.d",
      "echo 'DPkg::Options { \"--force-confdef\"; \"--force-confold\"; }' | sudo tee /etc/apt/apt.conf.d/local",
 
      # Mise à jour et installation silencieuse des paquets nécessaires
      "sudo apt-get upgrade -y",
      "sudo apt-get install -y python3 python3-pip sshpass",
 
      # Installation d'Ansible via pip3
      "pip3 install --upgrade pip",
      "pip3 install --user ansible",
     
      "python3 --version",
      "pip3 --version",
      "~/.local/bin/ansible --version"
      # "ansible --version"
    ]

    connection {
      type        = "ssh"
      host        = azurerm_dev_test_linux_virtual_machine.vmapp.fqdn
      user        = var.username_app
      private_key = file("./ssh/id_terraform")
      # private_key = file(local_file.private_key.filename)
    }
  }

  depends_on = [azurerm_dev_test_linux_virtual_machine.vmapp]
}


# Upload Ansible directory
resource "null_resource" "upload_ansible" {
  provisioner "file" {
    source      = "./ansible"
    destination = "/home/${var.username_app}/ansible"

    connection {
      type        = "ssh"
      host        = azurerm_dev_test_linux_virtual_machine.vmapp.fqdn
      user        = var.username_app
      private_key = file("./ssh/id_terraform")
      # private_key = file(local_file.private_key.filename)
    }
  } 
  depends_on = [null_resource.setup_ansible]
}



# # Upload SSH key (private)
# resource "null_resource" "upload_ssh_keys" {
#   provisioner "file" {
#     source      = "./ssh/id_terraform"
#     # source = local_file.private_key.filename
#     destination = "/home/${var.username_app}/.ssh/id_terraform"

#     connection {
#       type        = "ssh"
#       host        = azurerm_dev_test_linux_virtual_machine.vmapp.fqdn
#       user        = var.username_app
#       private_key = file("./ssh/id_terraform")
#       # private_key = file(local_file.private_key.filename)
#     }
#   }

#   provisioner "file" {
#     source      = "./ssh/id_terraform.pub"
#     # source = local_file.private_key.filename
#     destination = "/home/${var.username_app}/.ssh/id_terraform.pub"

#     connection {
#       type        = "ssh"
#       host        = azurerm_dev_test_linux_virtual_machine.vmapp.fqdn
#       user        = var.username_app
#       private_key = file("./ssh/id_terraform")
#       # private_key = file(local_file.private_key.filename)
#     }
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod 700 /home/${var.username_app}/.ssh",
#       "chmod 600 /home/${var.username_app}/.ssh/id_terraform",
#       "chmod 644 /home/${var.username_app}/.ssh/id_terraform.pub",
#       "touch /home/${var.username_app}/.ssh/authorized_keys",
#       "chmod 600 /home/${var.username_app}/.ssh/authorized_keys",
#       "cat /home/${var.username_app}/.ssh/id_terraform.pub >> /home/${var.username_app}/.ssh/authorized_keys",
#       # "touch /home/${var.username_app}/.ssh/config",
#       # "echo 'Host *' > /home/${var.username_app}/.ssh/config",
#       # "echo '    StrictHostKeyChecking no' >> /home/${var.username_app}/.ssh/config"
#       "echo 'HEEELLO \n \n '"
#     ]

#     connection {
#       type        = "ssh"
#       host        = azurerm_dev_test_linux_virtual_machine.vmapp.fqdn
#       user        = var.username_app
#       # private_key = file(local_file.private_key.filename)
#       private_key = file("./ssh/id_terraform")
#     }
#   }

#   depends_on = [azurerm_dev_test_linux_virtual_machine.vmapp, null_resource.upload_ansible]
# }

# # Convert the key to Unix format using dos2unix
# resource "null_resource" "format_ssh_key" {
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get install -y dos2unix",
#       "dos2unix --help",
#       "dos2unix /home/${var.username_app}/.ssh/id_terraform",
#       "dos2unix /home/${var.username_app}/.ssh/id_terraform.pub"

#       # "set -eux",
#       # "mkdir -p ~/.ssh",

#     ]

#     connection {
#       type        = "ssh"
#       host        = azurerm_dev_test_linux_virtual_machine.vmapp.fqdn
#       user        = var.username_app
#       # private_key = file(local_file.private_key.filename)
#       private_key = file("./ssh/id_terraform")
#     }
#   }

#   depends_on = [null_resource.upload_ssh_keys]
# }

# # Generate inventory (unchanged)
# resource "null_resource" "generate_inventory" {
#   provisioner "remote-exec" {
#     inline = [
#       "mkdir -p /home/${var.username_app}/ansible/inventories",
#       "cd /home/${var.username_app}/ansible/inventories",
#       "echo 'all:' > hosts.yml",
#       "echo '  hosts:' >> hosts.yml",
#       "echo '    azure_vm_one:' >> hosts.yml",
#       "echo '      ansible_host: ${azurerm_dev_test_linux_virtual_machine.vmapp.fqdn}' >> hosts.yml",
#       "echo '      ansible_user: ${var.username_app}' >> hosts.yml",
#       "echo '      ansible_ssh_private_key_file: /home/${var.username_app}/.ssh/id_terraform' >> hosts.yml",
#       "echo '      ansible_ssh_common_args: \"-o StrictHostKeyChecking=no\"' >> hosts.yml"
#     ]

#     connection {
#       type        = "ssh"
#       host        = azurerm_dev_test_linux_virtual_machine.vmapp.fqdn
#       user        = var.username_app
#       # private_key = file(local_file.private_key.filename)
#       private_key = file("./ssh/id_terraform")
#     }
#   }

#   depends_on = [null_resource.upload_ansible, null_resource.format_ssh_key]
  
#   # depends_on = [null_resource.upload_ansible]
# }

# # Run Ansible playbook
# resource "null_resource" "run_playbook" {
#   provisioner "remote-exec" {
#     inline = [
#       "ssh-keyscan -H ${azurerm_dev_test_linux_virtual_machine.vmapp.fqdn} >> ~/.ssh/known_hosts",
#       "~/.local/bin/ansible-playbook -i /home/${var.username_app}/ansible/inventories/hosts.yml /home/${var.username_app}/ansible/playbook.yml --extra-vars '${local.docker_env_vars_json}' -vv"
#     ]

#     connection {
#       type        = "ssh"
#       host        = azurerm_dev_test_linux_virtual_machine.vmapp.fqdn
#       user        = var.username_app
#       # private_key = file(local_file.private_key.filename)
#       private_key = file("./ssh/id_terraform")
#     }
#   }

#   depends_on = [null_resource.generate_inventory]
# }

# resource "null_resource" "my_local_exec_test_args" {
#   provisioner "local-exec" {
#   command = "echo $USER   - \n -\n - \n - \n -    $DOCKER_ARGS"
  
#   environment = {
#     USER = var.username_app
#     DOCKER_ARGS = local.docker_env_vars_json
#   }
#   }
#   depends_on = [null_resource.upload_ansible]
# }



resource "null_resource" "lunch_playbook" {
  provisioner "remote-exec" {
    inline = [
    <<-EOT
      /home/${var.username_app}/.local/bin/ansible-playbook -i localhost, --connection=local /home/${var.username_app}/ansible/playbook.yml --extra-vars '${local.docker_env_vars_json}' -vv
       EOT
    ]

    connection {
      type        = "ssh"
      host        = azurerm_dev_test_linux_virtual_machine.vmapp.fqdn
      user        = var.username_app
      private_key = file("./ssh/id_terraform")
      # private_key = file(local_file.private_key.filename)
    }


    #  /home/appuser99/.local/bin/ansible-playbook -i ~/ansible/inventories/hosts.yml, --connection=local /home/appuser99/ansible/playbook.yml --extra-vars '{"docker_env_vars":{"APP_KEY":"","AZ_FQDN":"deplinux-test.westeurope.cloudapp.azure.com","DB_CONNECTION":"mysql","DB_DATABASE":"laravel","DB_HOST":"db","DB_PASSWORD":"secret","DB_PORT":"3306","DB_ROOT_PASSWORD":"admin","DB_USERNAME":"laravel"}}' -v
    }
    depends_on = [null_resource.upload_ansible]
}