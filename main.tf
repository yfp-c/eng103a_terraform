# Terraform init - this command will download any required packages
# provider e.g. AWS
provider "aws" {
# which region e.g. Ireland
    region = "eu-west-1"
}
# init with terraform
# What do we want to launch
# Automate the process of creating an EC2 instance 

# name of resource
resource "aws_instance" "yacob_tf_app" {
  
# which AMI to use
  ami = "ami-07d8796a2b0f8d29c"

# what type of instance
  instance_type = "t2.micro"

# do you want a public IP?
  associate_public_ip_address = true
# what is the name of your instance
  tags = {
      Name = "eng103a_yacob_tf_app"
  }
}