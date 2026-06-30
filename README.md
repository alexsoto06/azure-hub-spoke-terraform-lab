# Azure Hub‑Spoke Lab Environment (Terraform Modular IaC)

This project deploys a complete **Azure hub‑and‑spoke lab environment** using **modular Terraform**.  
It is designed for learning, certification practice (AZ‑104, AZ‑700, AZ‑305), and real‑world IaC experience.

The environment includes:

- Hub VNet + Mgmt Subnet  
- Spoke VNet + App Subnet  
- NSGs for both subnets  
- Route table with virtual appliance route  
- VNet peering (hub ↔ spoke)  
- Four Windows VMs (Server 2022 + Windows 11)  
- Public IPs + NICs  
- Storage Account + Blob Container + File Share  
- Recovery Services Vault  
- Managed identity + Blob Data Reader role assignment  

All resources deploy into an **existing Azure Resource Group** (e.g., `ADS_Test_RG`).

---

## Project Structure

IAC LAB TERRAFORM/
├── modules/
│    ├── compute/
│    │    └── main.tf
│    ├── identity/
│    │    └── main.tf
│    ├── network/
│    │    └── main.tf
│    ├── storage/
│    │    └── main.tf
│    └── recovery/
│         └── main.tf
└── terraform/
├── main.tf
├── variables.tf
└── terraform.tfvars

Code

### Why modular?
- Clean separation of concerns  
- Easier maintenance  
- Reusable components  
- Enterprise‑grade IaC structure  
- Perfect for resume / GitHub portfolio  

---

## Architecture Overview

### Hub VNet (10.0.0.0/16)
- `mgmt-subnet` (10.0.1.0/24)  
- NSG: `nsg-mgmt`  
- VMs:
  - `vm-dc1` (Domain Controller)
  - `vm-file1` (File Server)

### Spoke VNet (10.1.0.0/16)
- `app-subnet` (10.1.1.0/24)  
- NSG: `nsg-app`  
- Route table: `rt-app`  
- VMs:
  - `vm-client1` (Windows 11 client)
  - `vm-app01` (Windows 11 app VM with managed identity)

### Additional Resources
- Storage Account (`staz104lab`)
  - Blob container: `blob-backups`
  - File share: `fs-shared`
- Recovery Services Vault (`rsv-az104`)
- Role assignment:
  - `vm-app01` → Storage Blob Data Reader

---

## ⚙️ Prerequisites

Before deploying:

1. Install:
   - Terraform ≥ 1.5
   - Azure CLI
2. Log in:
   ```bash
   az login
Ensure the resource group already exists:

bash
az group create -n ADS_Test_RG -l eastus
Update terraform.tfvars:

hcl
resource_group_name = "ADS_Test_RG"
admin_password      = "ChangeThisPassword123!"

Deployment Instructions
1. Initialize Terraform
bash
cd terraform
terraform init
2. Validate configuration
bash
terraform validate
3. Preview the deployment
bash
terraform plan
4. Deploy the environment
bash
terraform apply
5. Destroy the environment (optional)
bash
terraform destroy

Module Breakdown
Network Module
Creates:

Hub VNet

Spoke VNet

Subnets

NSGs

Route table

VNet peering

Outputs:

hub_vnet_id

spoke_vnet_id

mgmt_subnet_id

app_subnet_id

Compute Module
Creates:

4 Windows VMs

NICs

Public IPs

Managed identity for vm-app01

Outputs:

Private IPs

vm_app01_principal_id

Storage Module
Creates:

Storage account

Blob container

File share

Outputs:

Storage account name

Storage account ID

Identity Module
Creates:

Role assignment:

vm-app01 → Blob Data Reader

Recovery Module
Creates:

Recovery Services Vault

    Variables
Defined in variables.tf:

Variable	Description	Default
resource_group_name	Existing RG name	none
location	Azure region	eastus
admin_username	VM admin user	alexsoto
admin_password	VM admin password	required
home_public_ip	RDP source IP	71.201.33.162/32
vm_size	VM SKU	Standard_B1s
storage_account_name	Storage account name	staz104lab


 Future Expansion: Bicep Version
This README will later include:

Full modular Bicep architecture

Deployment instructions

Side‑by‑side comparison with Terraform

For now, the project is Terraform‑only.

 License
MIT License — free to use, modify, and share.

 Author
Created by Alex Soto  
IT Support Represenative