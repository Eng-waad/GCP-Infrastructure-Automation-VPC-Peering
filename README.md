# GCP-Infrastructure-Automation-VPC-Peering
Automation of Google Cloud VPC Peering and secure network connectivity using Terraform
# GCP VPC Peering & Connectivity Automation

This repository contains Terraform code to deploy a secure, multi-tier network architecture on Google Cloud Platform. It demonstrates how to connect two isolated VPCs and manage private traffic.

##  Key Features
- **VPC Peering:** Bidirectional private connection between `Frontend` and `Backend` networks.
- **Custom Subnetting:** Defined IP ranges for traffic isolation.
- **Granular Security:** Firewall rules restricted to internal IP ranges.
- **IAP Security:** Enabled Google Identity-Aware Proxy for secure SSH management without public IPs.

##  Tech Stack
- **Cloud Provider:** Google Cloud Platform (GCP)
- **IaC Tool:** Terraform
- **OS:** Debian 11
- **Services:** Compute Engine, VPC Network, Cloud Firewall, IAP.
- 
##  Connectivity Test
The infrastructure was validated by performing a **Ping (ICMP)** test from the Frontend Instance to the Backend Instance's private IP. The successful response confirms the Peering and Firewall configurations are functioning correctly.

##  Project Structure
- `main.tf`: Core Infrastructure as Code (IaC) file.
- `README.md`: Project documentation.
  - `.gitignore`: Config file to prevent temporary and sensitive Terraform files from being tracked.
- **`screenshots/`**: Directory containing proof-of-deployment:
  - `ping-test.png`: Validation of private bidirectional communication via ICMP.
  - `frontend-welcome.png`: Public access validation showing the active Apache web server.
