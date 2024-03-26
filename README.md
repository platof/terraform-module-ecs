# terraform-module-ecs

## Project Overview
This personal project is a simple nodejs project which is built using docker, pushed to AWS ECR and deployed to ECS using terraform. The aim of this project was to automate the deployment of a simple nodejs project using docker, terraform modules and github actions. 

## Deployment Overview
This project is automatically deployed when merging/pushing to the main branch using github actions. This is configured on .github/workflows/deploy.yml.

## Prerequsites:  
- AWS account
- Terraform
- AWS access credentials

## AWS Infrastructure Setup and Environment
This project was deployed using terraform configuation in us-east-1. Terraform module was used to deploy the AWS resources and infrastructure needed for the project such as:
- VPC, Subnets, Security Groups
- ECS cluster, Task definitions, Services
- IAM roles and Policies
- Load Balancer

## Terraform Configuration
The terraform configuration files which are located in the deployment folder for each environments in the ys-api repository consists of:
- main.tf: Describes the s3 backend configurations and required providers
- alb.tf: Sets up the Loadbalancer needed for the application and https configuration
- ecs.tf: Creates the ECS cluster, task definition and service
- provider.tf: Desribes the AWS Provider

## Deployment Process 
create a new .env file inside the environment located in the deployment folder with these variables:
| Variable Name | Type | Default | Description |
| ------------------------ | ------ | ------- | -------------------------------------------------------- |
| AWS_ACCESS_KEY_ID | string | N/A | AWS Access Key to for terraform |
| AWS_SECRET_ACCESS_KEY | string | N/A | AWS Secret Key for the associated access key |

### Docker Image
- deploy.yml file located in the .github/workflows directory contains the steps for creating the image repository before the image is built and tagged with docker and then pushed to AWS ECR.  

### Terraform Commands
Under the deployments folder we have 3 environments. (dev, uat, prod) Please specify the env before running the below commands like docker-compose -f deployment/**prod**/docker-compose.yml run --rm terra$
- To initialize terraform container, run `docker-compose -f deployment/docker-compose.yml run --rm terraform init`
- To validate terraform configurations, run `docker-compose -f deployment/docker-compose.yml run --rm terraform validate`
- To format the terraform configuration files, run `docker-compose -f deployment/docker-compose.yml run --rm terraform fmt`
- To check terraform resources to be created, run `docker-compose -f deployment/docker-compose.yml run --rm terraform plan`
- To apply the terraform configurations, run `docker-compose -f deployment/docker-compose.yml run --rm terraform apply`
- To destroy the instances createdd by terraform, run `docker-compose -f deployment/docker-compose.yml run --rm terraform destroy`


### Continuous Integration/Deployment(CI/CD)
Automatic deployment has been configured using github actions. This file is located in .github/workflows. When the code is pushed to the main branch. Environment variable secrets such as AWS_SECRET_KEY, AWS_SECRET_ACCESS_KEY, REPO_NAME needs to be configured in the Github repository's settings named Secrets and variables. 

### Monitoring and Logs
- Monitoring of the application health and performance can be viewed on AWS Cloudwatch and also AWS ECS  under health and metrics tab.
- Application logs can be viewed on Cloudwatch as well as ECS under the logs section.