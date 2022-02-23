# Infrastructure as Code with Terraform
## What is Terraform
### Terraform Architecture
#### Terraform default file/folder structure
##### .gitignore
###### AWS keys with Terraform security

![diagram](https://paradise-devs-media.s3.amazonaws.com/media/django-summernote/2020-02-13/3d4c1893-2a8a-4835-ac3f-fb117a5ce047.png)

**- Terraform commands**
- `terraform init` to initialise Terraform
- `terraform plan` reads script and checks everything. Will let you know of any syntax errors. 
- `terramform apply` implements the script
- `terraform destroy` deletes everything
- `terraform` to list all the commands that we can use with terraform

**- Terraform file/folder structure**
- `.tf` file extensions used in TF - `main.tf`
- To apply properly, implement `DRY` - `Don't Repeat Yourself!`

### Set up AWS as an ENV in windows machine
- `AWS_ACCESS_KEY_ID` for aws access keys
- `AWS_SECRET_ACCESS_KEY` for aws secret keys
- In order to get there, we can click the `windows` key on your keyboard. Enter type `env` and you'll see a pop-up - `edit the system environment variable`
- click on `new` for user variables
- add 2 environment variables 

Enter `terraform init` after editing main.tf file to include provider and region.

Creating a simple instance on AWS



To follow the DRY method, we can use variables:
# Terraform init - this command will download any required packages
# provider e.g. AWS
provider "aws" {
# which region e.g. Ireland
    region = var.region
}
# init with terraform
# What do we want to launch
# Automate the process of creating an EC2 instance 
```yml
 #name of resource
resource "aws_instance" "yacob_tf_app" {
  subnet_id = "subnet-08283d6ac22034598"
  vpc_security_group_ids = ["sg-0c254da9b24dfb05a"]
 #which AMI to use
  ami = var.app_ami_id

 #what type of instance
  instance_type = var.machine_type

 #do you want a public IP?
  associate_public_ip_address = true
 #what is the name of your instance
  tags = {
      Name = var.app_instance_name
  }
   #key name
  key_name = var.key_pair_name
}

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

```
With the variable file looking like...
```yml
variable "app_ami_id" {

 default = "ami-07d8796a2b0f8d29c"

 }

# create var or name, key, instance type, ip, tags
# use var in main.tf so we could utilise DRY

variable "machine_type" {

  default = "t2.micro"
}

variable "app_instance_name" {

    default = "eng103a_yacob_tf_app"
}

variable "key_pair_name" {

    default = "eng103a_yacob"
}

variable "region" {
    default = "eu-west-1"
}

variable "cidr_block" {
    default = "10.0.0.0/16"
}

variable "avail_zone" {
    default = "eu-west-1a"
}
```
To set up the app we made through terraform, we can use the ami of our ansible controller to configure our app.
