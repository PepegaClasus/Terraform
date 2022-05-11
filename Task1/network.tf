#Internet_Gateaway
resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.main_vpc_terraform.id
}

#ElasticIP
resource "aws_eip" "nat_eip1" {
  vpc        = true
  depends_on = [aws_internet_gateway.ig]
}

#NAT_Gateaway
resource "aws_nat_gateway" "privateNAT" {
  connectivity_type = "public"
  subnet_id = aws_subnet.public_subnet.id
  allocation_id = aws_eip.nat_eip1.id
  tags = {
    "Name" = "myNAT"
  }
}

#PublicRouteTable
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.main_vpc_terraform.id
    tags = {
      "Name" = "PublicRouteTable"
    }    
}

#PrivateRouteTable
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.main_vpc_terraform.id
    tags = {
      "Name" = "PrivateRouteTable"
    }
}

#Public Route
resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig.id
}

#Private Route
resource "aws_route" "private_nat_gateway" {
  route_table_id = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.privateNAT.id
}

#RouteTableAssociationPublic
resource "aws_route_table_association" "associate_public_subnet" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}
#RouteTableAssociationLoadBalancer2b
resource "aws_route_table_association" "associate_loadbalancer_subnet_2b" {
    subnet_id = aws_subnet.loadbalancer_subnet_2b.id
    route_table_id = aws_route_table.public_route_table.id
}
#RouteTableAssociationLoadBalancer2c
resource "aws_route_table_association" "associate_loadbalancer_subnet_2c" {
    subnet_id = aws_subnet.loadbalancer_subnet_2c.id
    route_table_id = aws_route_table.public_route_table.id
}



#RouteTableAssociationPrivate
resource "aws_route_table_association" "associate_private_subnet" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route_table.id
}

#SG
resource "aws_security_group" "EC2SG" {
    vpc_id = aws_vpc.main_vpc_terraform.id
    ingress  {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["37.214.42.24/32"]
    } 

    ingress  {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = ["${aws_security_group.LoadBalancerSG.id}"]
    }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }   

   tags = {
       Name = "EC2SGTerraform"
   }


  
}

resource "aws_security_group" "LoadBalancerSG" {
    vpc_id = aws_vpc.main_vpc_terraform.id
    ingress {
    from_port        = 80
    to_port          = 80
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
       Name = "LoadBalancerSGTerraform"
   }  
}