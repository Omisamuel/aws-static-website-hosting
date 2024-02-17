# AWS Static Website Hosting with Terraform

### **Automating Infrastructure Deployment with Terraform**

Host a Static Website on AWS S3 Using Terraform

In this project, I've streamlined the infrastructure setup for hosting a static website using Terraform, Amazon Web Services (AWS), and Tooplate Website. The primary objective is to showcase automated provisioning and deployment processes for hosting static websites.

_**Prerequisites:**_
1. AWS Account
2. AWS Configuration
3. Terraform Installation
4. IDE Installation: IntelliJ IDEA or Visual Studio Code
5. Bash Scripting Knowledge

## **Steps:**

### **Step 1: Set Up Your AWS Account**

1. Go to [AWS Signup](https://portal.aws.amazon.com/billing/signup#/start/email).
2. Navigate to IAM:
   - Create Security Credentials
   - Generate Access Keys
   - Save Access Keys Locally

### **Step 2: Set Up Your Development Environment**

1. Open Terminal:
   - Run `aws configure`
   - Enter Access Key ID
   - Enter Secret Access Key
   - Select region (e.g., eu-west-1)
   - Output format (e.g., json)

2. Install Terraform on your local environment
Visit [Terraform Installation](https://www.terraform.io/use-cases/infrastructure-as-code).

### **Step 3: Terraform Configuration File**

To create a Terraform configuration file, use `.tf` extension (e.g., `main.tf`) to define the infrastructure as code.

### **Step 4: Refer to AWS Documentation on Terraform**

Refer to the [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs):
1. Define the AWS provider:

```hcl
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.37.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}
```

2. Navigate to the directory containing your configuration files in your IDE's terminal. Run the following command to initialize Terraform and prepare it for use with AWS.

### **Step 5: Terraform Structure**

```
Folder Structure
└── Foldername
    ├── main.tf
    ├── resource
    ├── variable
    ├── output
    └── data
```

### **Step 6: Create a Tooplate Webserver Folder**

1. Create an [AWS instance](https://github.com/Omisamuel/aws-static-website-hosting/blob/Master/tooplate-webserver/main.tf) following the above structure.
2. add script to provision [tooplate-apache2-installer.sh](https://github.com/Omisamuel/aws-static-website-hosting/tree/Master/tooplate-apache2-script)
3. create ssh-key for Key Pairs to access aws. (change the public_key with your ssh-key name)
      - Open your terminal or command prompt.
      - Use the ssh-keygen command to generate a new SSH key pair. You can specify the name of the key pair and the directory where you want to save it
      - ssh-keygen -t rsa -b 2048 -f ~/.ssh/aws_key
      - Now, you can use the public key (aws_key.pub) in your AWS configurations. Replace "your_public_key" in the Terraform configuration with the name of your SSH key (e.g., aws_key.pub).
```
ssh-keygen -t rsa -b 2048 -f ~/.ssh/aws_key

public_key = "aws_key.pub"

```
Remember to keep the private key (aws_key) secure and never share it with anyone. This private key will be used for authentication when accessing AWS instances.

Once you have your SSH key pair generated and configured in your AWS account, you can use it to securely connect to your AWS instances via SSH.
   
   

### **Step 7: Create a Security Group Folder**

1. Ensure secure access to your website by creating a security group opening ports 22 (SSH), 80 (HTTP), and 443 (HTTPS).
2. Configure Inbound Rules for Security Group:
    - HTTP - port 80
    - HTTPS - port 443
    - SSH - port 22 (Use your IP Address for access)

### **Step 8: VPC Overview**

VPC (Virtual Private Cloud) and subnets are essential for AWS infrastructure, even for static websites, for several reasons:

- **Isolation and Security**: VPC isolates resources within the AWS cloud, enhancing security.
- **Network Segmentation**: Subnets allow logical organization of resources with different security policies.
- **Availability and Redundancy**: Deploy resources across multiple Availability Zones (AZs) for high availability.
- **Scalability**: VPC scales with infrastructure needs.
- **Traffic Management**: Subnets can be associated with route tables to direct traffic efficiently.

**Create VPC and Subnets (Networking)**
1. Choose the VPC region.
2. Create Public & Private Subnets (2 for each).
3. Create Route Tables and Associations.
4. Create an Internet Gateway.

### **Step 9: Load Balancer (Folder)**

Implement an Application Load Balancer (ALB) to distribute incoming network traffic across multiple servers or instances.

**Create Application Load Balancer (ALB)**
1. Add a load balancer target group.
2. Configure 2 load balancer listeners (HTTP - 80, HTTPS - 443).

**Create Load Balancer Target Group**
1. Add a load balancer target group.
2. Add a load balancer listener (HTTPS - 443).

### **Step 10: Creating Certificate Manager and Route 53 (Folder)**

**Creating an SSL Certificate with ACM**

Request SSL certificates for your main domain and subdomains in ACM. Configure CNAME records in Route 53 for SSL certificate validation.

**Configuring Route 53**

Set up Route 53 to link your domain name to the main static website bucket.

### **Step 11: remote_backend_s3.tf**
1. create s3 bucket
2. add s3 bucket to EC2 instance region 

### **Step 12: Working with Terraform Security**

Security is paramount when working with Terraform, especially when managing infrastructure in cloud environments.

To enhance security and manage sensitive information effectively, follow these steps:

**1. Create `terraform.tfvars` file**

Create a file named `terraform.tfvars` in your Terraform project directory.

**2. Add the following sensitive variables in `terraform.tfvars`:**

```hcl
vpc_cidr            = "your_vpc_cidr"
vpc_name            = "your_vpc_name"
cidr_public_subnet  = "your_public_subnet_cidr"
cidr_private_subnet = "your_private_subnet_cidr"
availability_zone   = "your_availability_zone"
public_key          = "your_public_key"
ec2_ami_id          = "your_ec2_ami_id"
domain_name         = "your_domain_name"
bucket_name         = "your_bucket_name"
```

Ensure you replace `"your_value"` placeholders with your actual sensitive information.

**3. Protect `terraform.tfvars`**

- Ensure `terraform.tfvars` is included in your `.gitignore` file to prevent accidental exposure of sensitive information.
- Store `terraform.tfvars` securely, possibly encrypted, and limit access only to authorized personnel.
- Utilize a secrets management tool if available for secure storage and retrieval of sensitive information.

By following these steps, you can effectively manage sensitive data and enhance the security of your Terraform infrastructure provisioning process.

