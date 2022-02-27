# Terraform init - this command will download any required packages
# provider e.g. AWS
provider "aws" {
# which region e.g. Ireland
    region = var.region
}
# init with terraform
# What do we want to launch
# Automate the process of creating an EC2 instance 

#  #name of resource
# resource "aws_instance" "yacob_tf_app" {
#   subnet_id = "subnet-08283d6ac22034598"
#   vpc_security_group_ids = ["sg-0ceeacc84f2620105"]
#  #which AMI to use
#   ami = var.app_ami_id

#  #what type of instance
#   instance_type = var.machine_type

#  #do you want a public IP?
#   associate_public_ip_address = true
#  #what is the name of your instance
#   tags = {
#       Name = var.app_instance_name
#   }
#    #key name
#   key_name = var.key_pair_name
# }

resource "aws_vpc" "eng103_yacob_tf_vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"

    tags = {
        Name = "eng103a_yacob_vpc_tf"
    }
}

resource "aws_subnet" "eng103_yacob_tf_vpc_publicSN" {
vpc_id     = aws_vpc.eng103_yacob_tf_vpc.id
cidr_block = "10.0.11.0/24"
map_public_ip_on_launch = true
availability_zone = var.avail_zone

tags = {
 Name = "eng103_yacob_tf_vpc_publicSN"
 }
}

resource "aws_subnet" "eng103_yacob_tf_vpc_publicSN2" {
vpc_id     = aws_vpc.eng103_yacob_tf_vpc.id
cidr_block = "10.0.12.0/24"
map_public_ip_on_launch = true
availability_zone = "eu-west-1b"

tags = {
 Name = "eng103_yacob_tf_vpc_publicSN2"
 }
}

resource "aws_subnet" "eng103_yacob_tf_vpc_publicSN3" {
vpc_id     = aws_vpc.eng103_yacob_tf_vpc.id
cidr_block = "10.0.13.0/24"
map_public_ip_on_launch = true
availability_zone = "eu-west-1c"

tags = {
 Name = "eng103_yacob_tf_vpc_publicSN3"
 }
}

resource "aws_security_group" "yacob_sg_app" {
  name        = "eng103a_yacob_tf_sg_app"
  description = "Allow inbound traffic"
  vpc_id = aws_vpc.eng103_yacob_tf_vpc.id
  
  ingress {
    description      = "access to the app"
    from_port        = "80"
    to_port          = "80"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  # ssh access
  ingress {
    description      = "ssh access"
    from_port        = "22"
    to_port          = "22"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }
 # Allow port 3000 from anywhere
  ingress {
    from_port        = "3000"
    to_port          = "3000"
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

    }

egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" 
    cidr_blocks      = ["0.0.0.0/0"]
  }

      tags = {
        Name = "eng103a_yacob_tf_sg_app"
    }
}

resource "aws_internet_gateway" "eng103a_yacob_tf_igw" {
vpc_id = aws_vpc.eng103_yacob_tf_vpc.id

tags = {
    Name = "eng103a_yacob_tf_igw"
  }
}

resource "aws_route_table" "eng103a_yacob_tf_rt" {
vpc_id = aws_vpc.eng103_yacob_tf_vpc.id

route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eng103a_yacob_tf_igw.id
    }

 tags = {
     Name = "eng103a_yacob_tf_rt"
  }
}

resource "aws_route_table_association" "eng103a_yacob_tf_subnet_association" {
  route_table_id = aws_route_table.eng103a_yacob_tf_rt.id
  subnet_id = aws_subnet.eng103_yacob_tf_vpc_publicSN.id
}

# resource "aws_launch_configuration" "as_conf_tf_yacob" {
#   name          = "as_conf_tf_yacob"
#   image_id      = var.app_ami_id.id
#   instance_type = "t2.micro"
# }

# resource "aws_autoscaling_group" "yacob_tf" {
#   min_size             = 1
#   max_size             = 3
#   desired_capacity     = 1
#   launch_configuration = aws_launch_configuration.as_conf_tf_yacob.id
# }

