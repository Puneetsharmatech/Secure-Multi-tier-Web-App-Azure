# Secure Multi-Tier Web Application on Azure with Terraform and GitHub Actions 🔒🌐

### Project Overview

This project demonstrates the design, deployment, and automation of a secure, highly-available, multi-tier web application on Microsoft Azure. The entire infrastructure is defined as code using **Terraform** and deployed via a **Continuous Integration/Continuous Deployment (CI/CD)** pipeline using **GitHub Actions**.

The architecture consists of a public-facing web front-end and a private, isolated database back-end. The solution emphasizes security by implementing network segmentation, a Web Application Firewall (WAF), and centralized secrets management.

<br>

<br>

***

### Architecture Breakdown

The application is built on the following core Azure services, all provisioned and managed by Terraform:

* **Virtual Network (VNet) & Subnets**: A logically isolated network with separate subnets for the web and database tiers, enforcing network segmentation.
* **Network Security Groups (NSGs)**: Applied to each subnet to filter network traffic, ensuring only necessary communication is allowed between components.
* **Azure Application Gateway with WAF**: The sole public entry point to the application. It acts as a Layer 7 load balancer and includes a **Web Application Firewall** to protect against common web vulnerabilities like SQL injection and cross-site scripting.
* **Azure App Service**: Hosts the web application and is configured to only accept inbound traffic from the Application Gateway.
* **Azure Database for PostgreSQL (or MySQL)**: The managed database service. It is deployed in a private subnet and is **not publicly accessible**.
* **Azure Private Endpoint**: Creates a private, secure connection between the App Service and the database, routing traffic over the VNet instead of the public internet.
* **Azure Key Vault**: Used for secure storage and management of sensitive information, such as the database connection string. The web application retrieves this secret at runtime, eliminating hardcoded credentials.

***

### Security Implementations

* **Principle of Least Privilege**: NSGs are strictly configured to allow only essential traffic. For example, the database subnet's NSG denies all inbound traffic except for the web application's subnet.
* **Private Connectivity**: The database is fully isolated from the public internet. The web application connects to it securely using an Azure Private Endpoint. This is a critical security measure to prevent data exfiltration and unauthorized access.
* **Web Application Firewall (WAF)**: The Application Gateway's WAF protects the application from a wide range of common threats, providing an additional layer of security at the application level.
* **Secrets Management**: All sensitive data is stored in Azure Key Vault. The GitHub Actions pipeline and the application itself are configured to authenticate with Key Vault and retrieve secrets, preventing credentials from being stored in code or configuration files.

***

### CI/CD Pipeline with GitHub Actions

The project leverages two distinct GitHub Actions workflows to automate the deployment process:

1.  **IaC Pipeline (`terraform.yml`)**:
    * **Trigger**: Pushes to the `main` branch and pull requests affecting the `terraform/` directory.
    * **Jobs**: Automatically runs `terraform fmt`, `terraform validate`, `terraform plan`, and `terraform apply`.
    * **Authentication**: Uses a dedicated Azure Service Principal with OpenID Connect (OIDC) for secure, secret-less authentication with Azure.
    * **Status**: [![Terraform IaC](https://github.com/Puneet-web-dev/secure-multi-tier-web-app-azure/actions/workflows/terraform.yml/badge.svg)](https://github.com/Puneet-web-dev/secure-multi-tier-web-app-azure/actions/workflows/terraform.yml)

2.  **Application Pipeline (`application.yml`)**:
    * **Trigger**: Pushes to the `main` branch affecting the `application/` directory.
    * **Jobs**: Builds the application code (e.g., a Docker image) and deploys it to the Azure App Service.
    * **Status**: [![Application CI/CD](https://github.com/Puneet-web-dev/secure-multi-tier-web-app-azure/actions/workflows/application.yml/badge.svg)](https://github.com/Puneet-web-dev/secure-multi-tier-web-app-azure/actions/workflows/application.yml)

***

### How to Deploy and Test

To deploy this project from scratch, you must have the Azure CLI and Terraform installed.

1.  **Clone the Repository**:
    `git clone https://github.com/Puneet-web-dev/secure-multi-tier-web-app-azure.git`

2.  **Configure Azure Service Principal**:
    * Run the Azure CLI commands provided in the project's documentation to create a Service Principal with a federated credential.
    * Store the resulting `AZURE_CLIENT_ID`, `AZURE_SUBSCRIPTION_ID`, and `AZURE_TENANT_ID` as secrets in your GitHub repository.

3.  **Create the Terraform State Backend**:
    * Manually create the resource group, storage account, and blob container in Azure to store your Terraform state file.

4.  **Trigger the Deployment**:
    * Push your changes to the `main` branch. This will automatically trigger the `terraform.yml` workflow, which will provision all the Azure infrastructure.
    * Once the infrastructure is ready, push your application code to trigger the `application.yml` workflow, which will build and deploy the application.

5.  **Test the Application**:
    * Once the deployment is complete, navigate to the public URL of the Application Gateway to access your web application.

***

### Repository Structure

