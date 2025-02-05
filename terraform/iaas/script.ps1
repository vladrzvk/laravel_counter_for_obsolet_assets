# PowerShell version du script

function Show-Help {
    Write-Host "### How to use:" -ForegroundColor Yellow
    Write-Host "Possible parameters: create or destroy."
    Write-Host "Ex: .\script.ps1 create"
}

function Invoke-Create {
    Write-Host "`nTerraform init`n" -ForegroundColor Green
    terraform init

    Write-Host "`nTerraform plan`n" -ForegroundColor Green
    terraform plan -out=tfplan

    Write-Host "`nTerraform apply`n" -ForegroundColor Green
    terraform apply tfplan

    if ($LASTEXITCODE -ne 0) {
        Write-Host "An error occurred while applying infrastructure with Terraform" -ForegroundColor Red
        exit 1
    }

    Write-Host "`nOutput Lab Name:`n" -ForegroundColor Green
    $lab_name = terraform output -raw lab_name
    Write-Host "$lab_name`n"

    Write-Host "`nOutput Resource Group Name:`n" -ForegroundColor Green
    $resource_group_name = terraform output -raw resource_group_name
    Write-Host "$resource_group_name`n"

    Write-Host "`nOutput VM Names:`n" -ForegroundColor Green
    $raw_vm_names = terraform output vm_names
    # Supprime les crochets, guillemets et remplace les virgules par des espaces
    $vm_names_output = $raw_vm_names -replace "[\[\]\"]", "" -replace ",", " "
    $vm_names = $vm_names_output.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    Write-Host ($vm_names -join " ") "`n"

    Write-Host "`nOutput VM IP addresses:`n" -ForegroundColor Green
    $ipaddresses = @()
    foreach ($vm_name in $vm_names) {
        $vm = $vm_name.ToLower()
        $ipJson = az network public-ip show --resource-group $resource_group_name --name $vm | ConvertFrom-Json
        $ip = $ipJson.ipAddress
        $ipaddresses += $ip
    }
    Write-Host ($ipaddresses -join " ") "`n"

    Write-Host "`nOutput VM FQDNs:`n" -ForegroundColor Green
    $raw_vm_fqdns = terraform output vm_fqdn
    $vm_fqdns_output = $raw_vm_fqdns -replace "[\[\]\"]", "" -replace ",", " "
    $vm_fqdns = $vm_fqdns_output.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    Write-Host ($vm_fqdns -join " ") "`n"

    # Write-Host "`nClaiming VMs:`n" -ForegroundColor Green
    # foreach ($vm_name in $vm_names) {
    #     Write-Host "$vm_name`n"
    #     az lab vm claim -g $resource_group_name --lab-name $lab_name --name $vm_name | Out-Null
    # }

    # Write-Host "`nCreating Ansible hosts.yml:`n" -ForegroundColor Green
    # $inventoryPath = "ansible/inventory/hosts.yml"
    # "all:`n  hosts:" | Out-File -FilePath $inventoryPath -Encoding utf8

    # Write-Host "`nCompleting hosts.yml with FQDNs:`n" -ForegroundColor Green
    # foreach ($vm_fqdn in $vm_fqdns) {
    #     Write-Host "$vm_fqdn`n"
    #     "    $vm_fqdn:" | Out-File -FilePath $inventoryPath -Append -Encoding utf8
    # }

    # Write-Host "`nRunning Ansible playbook:`n" -ForegroundColor Green
    # ansible-playbook -i ansible/inventory/hosts.yml ansible/configuration.yml
}

function Invoke-Destroy {
    terraform destroy --auto-approve
}

# Point d'entrée selon l'argument passé
if ($args.Count -eq 0) {
    Show-Help
} elseif ($args[0].ToLower() -eq "create") {
    Invoke-Create
} elseif ($args[0].ToLower() -eq "destroy") {
    Invoke-Destroy
} else {
    Show-Help
}
