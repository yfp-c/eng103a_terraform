# Terraform init - this command will download any required packages
# provider e.g. AWS
provider "aws" {
# which region e.g. Ireland
  region = "eu-west-1"
}
# init with terraform
# What do we want to launch