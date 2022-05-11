#VPC
resource "aws_vpc" "main_vpc_terraform" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "MyTerraformVPC"
    }
}

#PublicSubnet
resource "aws_subnet" "public_subnet" {
    vpc_id = "${aws_vpc.main_vpc_terraform.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-2a"
    tags = {
      "Name" = "public_subnet"
    }
}

#PrivateSubnet
resource "aws_subnet" "private_subnet" {
    vpc_id = "${aws_vpc.main_vpc_terraform.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-2b"
    tags = {
      "Name" = "private_subnet"
    }
}

#LoadBalancerSubnet2b
resource "aws_subnet" "loadbalancer_subnet_2b" {
    vpc_id = "${aws_vpc.main_vpc_terraform.id}"
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-2b"
    tags = {
      "Name" = "LoadBalancer_subnet_2b"
    }
}

#LoadBalancerSubnet2c
resource "aws_subnet" "loadbalancer_subnet_2c" {
    vpc_id = "${aws_vpc.main_vpc_terraform.id}"
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-2c"
    tags = {
        "Name" = "LoadBalancer_subnet_2c"
    }
}