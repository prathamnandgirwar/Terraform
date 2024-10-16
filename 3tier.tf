# VPC
resource "aws_vpc" "vnet" {
    cidr_block = "172.168.0.0/16"
}

# Public Subnet 1
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vnet.id
    cidr_block = "172.168.0.0/22"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
}

# Private Subnet
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.vnet.id
    cidr_block = "172.168.4.0/22"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = false
}

# Public Subnet 2
resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.vnet.id
    cidr_block = "172.168.8.0/22"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true
}

# Internet Gateway
resource "aws_internet_gateway" "net" {
    vpc_id = aws_vpc.vnet.id
}

# Public Route Table
resource "aws_route_table" "rt-pub" {
    vpc_id = aws_vpc.vnet.id

    route {
        gateway_id = aws_internet_gateway.net.id
        cidr_block = "0.0.0.0/0"
    }
}

# Associate Public Subnet 1 with Public Route Table
resource "aws_route_table_association" "pub1" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.rt-pub.id
}

# Associate Public Subnet 2 with Public Route Table 
resource "aws_route_table_association" "pub2" {
    subnet_id      = aws_subnet.public2.id
    route_table_id = aws_route_table.rt-pub.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "dynamic" {
    domain = "vpc"
}

# NAT Gateway in Public Subnet 1
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.dynamic.id
    subnet_id     = aws_subnet.public.id
}

# Private Route Table
resource "aws_route_table" "rt-priv" {   
    vpc_id = aws_vpc.vnet.id

    route {
        nat_gateway_id = aws_nat_gateway.nat.id
        cidr_block = "0.0.0.0/0"
    }
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "rt-private" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.rt-priv.id
}

# Security Group
resource "aws_security_group" "ag" {
    name   = "bg-b42"
    vpc_id = aws_vpc.vnet.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

# EC2 Instance in Public Subnet 1
resource "aws_instance" "web" {
    ami                    = "ami-0dee22c13ea7a9a67"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.public.id
    vpc_security_group_ids = [ aws_security_group.ag.id ]
}

# EC2 Instance in Private Subnet
resource "aws_instance" "app" {
    ami                    = "ami-0dee22c13ea7a9a67"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.private.id
    vpc_security_group_ids = [ aws_security_group.ag.id ]
}

# EC2 Instance in Public Subnet 2
resource "aws_instance" "data" {
    ami                    = "ami-0dee22c13ea7a9a67"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.public2.id
    vpc_security_group_ids = [ aws_security_group.ag.id ]
}
