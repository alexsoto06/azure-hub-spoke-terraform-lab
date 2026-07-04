# Azure Hub-Spoke Lab Environment with Terraform CI/CD

This project deploys a complete Azure hub-and-spoke lab environment using modular Terraform and GitHub Actions.

The lab was built to demonstrate real-world Azure administration, Infrastructure as Code (IaC), CI/CD automation, remote state management, security controls, and cost governance.

Technologies used:

- Azure
- Terraform
- GitHub Actions
- Azure Storage
- Azure Key Vault
- Managed Identity
- Azure RBAC
- Windows Server
- Windows 11

---

## Architecture Overview

This environment uses a hub-and-spoke network topology.

### Hub Network

```text
hub-vnet
Address Space: 10.0.0.0/16

mgmt-subnet
10.0.1.0/24

VMs:
- vm-dc1
- vm-file1
```

### Spoke Network

```text
spoke-vnet
Address Space: 10.1.0.0/16

app-subnet
10.1.1.0/24

VMs:
- vm-client1
- vm-app01
```

### Connectivity

```text
hub-vnet <--> spoke-vnet
```

The spoke subnet is associated with a route table and network security group to simulate enterprise network segmentation.

### Network Topology

![Project Logo](screenshots/network-topology.png "My Project Logo")



---

## Deployed Resources

### Networking

- Hub VNet
- Spoke VNet
- Management subnet
- Application subnet
- NSGs
- Route table
- Hub-to-spoke VNet peering
- Spoke-to-hub VNet peering

### Compute

- vm-dc1 (Windows Server 2019)
- vm-file1 (Windows Server 2019)
- vm-client1 (Windows 11 Pro)
- vm-app01 (Windows 11 Pro)

### Storage

- Azure Storage Account
- Blob Container
- Azure Files Share

### Identity & Security

- User Assigned Managed Identity
- Azure RBAC Role Assignment
- Azure Key Vault
- GitHub Secrets

### Recovery

- Recovery Services Vault

### Resource Group Deployment

![Project Logo](screenshots/resource-group-overview.png "My Project Logo")


---

## CI/CD Pipeline

This project uses GitHub Actions to automate Terraform deployments.

Pipeline workflow:

1. Checkout Repository
2. Azure Authentication
3. Terraform Init
4. Terraform Plan
5. Terraform Apply

GitHub repository secrets are used for authentication.

### GitHub Actions Deployment


![Project Logo](screenshots/github-actions-success.png "My Project Logo")

---

## Remote State Management

Terraform state is stored remotely in Azure Blob Storage using the AzureRM backend.

Benefits:

- Persistent Terraform state
- State locking
- Protection from lost local state
- Consistent GitHub Actions deployments

```hcl
backend "azurerm" {
  resource_group_name  = "ADS_Test_RG"
  storage_account_name = "tfstatealexsoto"
  container_name       = "tfstate"
  key                  = "az104-lab.tfstate"
}
```

### Remote State Storage

![Project Logo]((screenshots/remote-state-blob.png) "My Project Logo")

---

## Security Controls

Implemented security controls include:

- Azure Key Vault
- Azure RBAC
- User Assigned Managed Identity
- GitHub Secrets
- Network Security Groups
- Restricted RDP Access
- Remote Terraform State

### Key Vault & Managed Identity

Azure Key Vault has been deployed to support centralized secret management.

The environment also includes a User Assigned Managed Identity for `vm-app01` and RBAC-based access control.

Planned Enhancement:

```text
Terraform retrieves VM administrator credentials
directly from Azure Key Vault.
```

### Security Resources

![Project Logo](screenshots/key-vault-managed-identity.png) "My Project Logo")

---

## Cost Management

To maintain a low-cost lab environment, the following controls were implemented:

- Azure Budget Alerts
- Resource Group Cost Analysis
- VM Auto Shutdown
- Budget Monitoring
- Low-cost VM sizing

Target monthly budget:

```text
< $50/month
```

Primary cost drivers:

```text
Virtual Machines
```

### Budget Monitoring

![Project Logo](screenshots/budget-alerts.png) "My Project Logo")

---

## Key Accomplishments

- Built reusable Terraform modules
- Designed and deployed a hub-and-spoke Azure network
- Implemented GitHub Actions CI/CD
- Configured Azure Storage remote state
- Implemented Azure RBAC and Managed Identity
- Deployed Azure Key Vault
- Implemented Azure cost governance using budgets and alerts
- Automated deployment of Azure infrastructure through Infrastructure as Code

---

## Deployment

```bash
git clone <repository-url>

cd terraform

terraform init

terraform plan

terraform apply
```

Terraform state is stored remotely in Azure Blob Storage.

Sensitive configuration values are intentionally excluded from source control.

---

## Current Limitations

- Public IPs are attached to lab VMs for accessibility
- Azure Bastion is not deployed to reduce cost
- Just-In-Time VM Access has not yet been implemented
- Full Key Vault integration for VM password deployment is planned

---

## Future Enhancements

- Azure Defender for Cloud
- Just-In-Time VM Access
- Log Analytics Workspace
- Azure Bastion
- Backup Policies
- Azure Policy Assignments
- Bicep Version of the Environment
- Private Endpoints

---

## Skills Demonstrated

- Terraform
- Infrastructure as Code
- Azure Networking
- Hub-and-Spoke Architecture
- Azure Virtual Machines
- Azure Storage
- Azure RBAC
- Managed Identities
- Azure Key Vault
- GitHub Actions
- CI/CD
- Azure Cost Management
- Network Security Groups
- Cloud Automation

---

## Resume Summary

```text
Designed and deployed a modular Azure hub-and-spoke environment using Terraform and GitHub Actions, including VNets, NSGs, route tables, Windows virtual machines, Azure Storage, Recovery Services Vault, Azure RBAC, Managed Identity, Azure Key Vault, remote Terraform state, CI/CD automation, and Azure cost governance controls.
```

---

## Author

Alex Soto

IT Support | Software Development | Master's Degree in Software Development @ Dominican Univeristy, River Forest, IL

Certifications:

- SC-300 Identity and Access Administrator
- MD-102 Endpoint Administrator

---

## License

MIT License
