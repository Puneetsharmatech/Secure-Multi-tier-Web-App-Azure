# Secure-Multi-tier-Web-App-Azure

### 🌐 Project Overview

This project demonstrates the design and deployment of a secure, highly-available, multi-tier web application on **Microsoft Azure**. The entire infrastructure is defined using **Terraform** and automatically deployed via **GitHub Actions** CI/CD pipelines. It showcases key DevOps and cloud engineering practices, including Infrastructure as Code (IaC), robust network security, and automated deployments.

---

### 🏛️ Architecture

Our application is a simple CRUD web app protected by a **Web Application Firewall (WAF)**. The database is secured with a **private endpoint**, ensuring it's never publicly accessible. All secrets are managed via **Azure Key Vault**.

![Architectural Diagram](https://i.imgur.com/your-diagram-image-link.png)

* **Azure Application Gateway**: Acts as the single public entry point with an integrated WAF.
* **Virtual Network (VNet)**: Segments the network with dedicated subnets for the web and database tiers.
* **Azure App Service**: Hosts the web application within a private subnet.
* **Azure Database**: A managed database service (e.g., PostgreSQL) accessible only from within the VNet.
* **Azure Private Endpoint**: Connects the web app to the database securely over the private network.
* **Azure Key Vault**: Stores sensitive information like the database connection string.

---

### 🚀 CI/CD & Automation

We use two distinct **GitHub Actions** workflows to manage the project:

| Pipeline | Description | Trigger |
| :--- | :--- | :--- |
| **IaC Pipeline** | Provisions and updates all Azure infrastructure. | `push` to `terraform/` directory |
| **App Pipeline** | Builds and deploys the web application to App Service. | `push` to `app/` directory |

[**Explore the latest pipeline runs here!**](https://github.com/your-username/Secure-Multi-tier-Web-App-Azure/actions)

---

### 🛠️ How to Deploy

1.  **Prerequisites**:
    * An active Azure subscription.
    * **Azure CLI** and **Terraform** installed.
2.  **Authentication**:
    * Create an Azure Service Principal and add its credentials as repository secrets in GitHub (`AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, etc.).
3.  **Clone the Repo**:
    ```sh
    git clone [https://github.com/Puneetsharmatech/Secure-Multi-tier-Web-App-Azure.git](https://github.com/puneetsharmatech/Secure-Multi-tier-Web-App-Azure.git)
    ```
4.  **Initiate Deployment**:
    * Push your configured code to the `main` branch. The pipelines will automatically provision the infrastructure and deploy the application.

---
