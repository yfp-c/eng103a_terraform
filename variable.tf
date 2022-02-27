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

    default = "eng103a_yacob2"
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