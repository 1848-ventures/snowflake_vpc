# AWS VPC Terraform Module

This repository contains a Terraform module for deploying a highly available and secure Virtual Private Cloud (VPC) on Amazon Web Services (AWS). It includes configurations for VPC, subnets, and Network ACLs, specifically tailored for secure connectivity to Snowflake PrivateLink.

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Modules](#modules)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Initialization](#initialization)
  - [Planning](#planning)
  - [Applying Changes](#applying-changes)
  - [Destroying Resources](#destroying-resources)
- [Monitoring and Alerting](#monitoring-and-alerting)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [License](#license)

## Project Overview

This Terraform project provides a robust and scalable AWS network infrastructure for secure and highly available connections from on-premise VPN to Snowflake PrivateLink. It leverages AWS best practices for high availability and security, setting up a multi-Availability Zone (AZ) VPC with public and private subnets.

## Architecture

The architecture deployed by this Terraform module includes:

-   **VPC (Virtual Private Cloud):** A logically isolated section of the AWS Cloud where you can launch AWS resources in a virtual network that you define.
-   **Public Subnets:** Subnets that have a direct route to an Internet Gateway, allowing resources within them to communicate with the internet.
-   **Private Subnets:** Subnets that do not have a direct route to an Internet Gateway. Resources in private subnets can access the internet via NAT Gateways.
-   **NAT Gateways:** Network Address Translation (NAT) gateways deployed in public subnets to allow instances in private subnets to connect to the internet or other AWS services, but prevent the internet from initiating connections with those instances.
-   **Security Groups:** Act as virtual firewalls that control inbound and outbound traffic for your instances.
-   **Network ACLs:** An optional layer of security for your VPC that acts as a firewall for controlling traffic in and out of one or more subnets.
-   **Snowflake PrivateLink:** Secure and private connectivity to Snowflake services within your VPC.

## Modules

This project is organized into the following Terraform modules:

-   **`vpc`:** Creates the VPC, subnets, internet gateway, NAT gateway, and route tables.
-   **`sg`:** Creates security groups.
-   **`nacl`:** Creates a network ACL with a default set of rules.
-   **`snowflake_private_access`:** Configures Snowflake PrivateLink access.
 -   **`dns_resolver`:** Configures DNS resolution for Snowflake PrivateLink.
-   **`s3_endpoint`:** Creates a VPC endpoint for S3.
-   **`vpn`:** Configures VPN connection.

## Features

-   **High Availability:** Multi-AZ deployment for VPC and subnets to ensure fault tolerance.
-   **Scalability:** Infrastructure designed to be easily scaled horizontally.
-   **Security:** Implementation of security groups and network ACLs to control traffic flow, and secure private connectivity to Snowflake via PrivateLink.
-   **Automated Deployment:** Infrastructure as Code (IaC) using Terraform for consistent and repeatable deployments.

## Prerequisites

Before you begin, ensure you have the following:

-   [AWS Account](https://aws.amazon.com/)
-   [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials and default region.
-   [Terraform](https://www.terraform.io/downloads.html) installed (v1.0.0 or later recommended).

## Getting Started

1.  **Clone the repository:**

    ```bash
    git clone <repository-url>
    cd vpc_mod
    ```

2.  **Review and customize variables:**

    Open `variables.tf` and `terraform.tfvars` (if it exists, otherwise create it) to customize the deployment according to your needs. Key variables include:

    -   `region`: AWS region for deployment (default: `us-east-1`).
    -   `environment`: Deployment environment (e.g., `stg`, `prod`).
    -   `vpc_cidr`: CIDR block for your VPC.
    -   `public_sub_cidr`: List of CIDR blocks for public subnets.
    -   `priv_sub_cidr`: List of CIDR blocks for private subnets.
    -   `public_subnet_az`: List of Availability Zones for public subnets.
    -   `private_subnet_az`: List of Availability Zones for private subnets.
    -   `onprem_network_cidrs`: CIDR blocks for your on-premise network.

### Initialization

Initialize your Terraform working directory. This command downloads the necessary providers and modules.

```bash
terraform init
```

### Planning

Review the execution plan before applying any changes. This command shows you what Terraform will do.

```bash
terraform plan
```

### Applying Changes

Apply the planned changes to provision the infrastructure.

```bash
terraform apply
```

### Destroying Resources

To tear down all the provisioned resources, run the following command:

```bash
terraform destroy
```

## Monitoring and Alerting

Monitoring and alerting should be configured for the VPN connection and Snowflake PrivateLink. Consider using AWS CloudWatch for VPN tunnel status and network traffic metrics.

## Security Considerations

-   **Least Privilege:** Ensure IAM roles and policies adhere to the principle of least privilege.
-   **Network ACLs & Security Groups:** Carefully review and restrict inbound/outbound rules to only necessary traffic.
-   **VPC Flow Logs:** Enabled for network traffic visibility and troubleshooting.
	
## Contributing

Contributions are welcome! Please feel free to open issues or submit pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.