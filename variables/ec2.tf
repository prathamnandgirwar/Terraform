

 resource "aws_vpc" "vnet" {
     cidr_block = var.vpc_cidr_block
 }

 resource "aws_subnet" "public" {
     vpc_id = aws_vpc.vnet.id
     cidr_block = var.aws_subnet2[0]
     availability_zone = var.az[0]
     map_public_ip_on_launch = var.public_ip
 }
 resource "aws_internet_gateway" "igw-demo" {
    vpc_id = aws_vpc.vnet.id 
 }
 resource "aws_route_table" "rt-publ" {
    vpc_id = aws_vpc.vnet.id
    route {
        gateway_id = aws_internet_gateway.igw-demo.id
        cidr_block = "0.0.0.0/0"
    }
   
 }
 resource "aws_route_table_association" "rt-atach" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.rt-publ.id
 }
 resource "aws_security_group" "ng" {
    vpc_id = aws_vpc.vnet.id

    ingress {
        from_port = var.port_no[0]
        to_port = var.port_no[0]
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        from_port = var.port_no[1]
        to_port = var.port_no[1]
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        from_port = var.port_no[2]
        to_port = var.port_no[2]
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    ingress {
        from_port = var.port_no[3]
        to_port = var.port_no[3]
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = var.port_no[4]
        to_port = var.port_no[4]
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
 }

 resource "aws_instance" "apache" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.ng.id]
   
 }
