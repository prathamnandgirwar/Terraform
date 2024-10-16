resource "aws_vpc" "vnet" {
    cidr_block = "172.168.0.0/16"
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vnet.id
    cidr_block = "172.168.0.0/22"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
  
}
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.vnet.id
    cidr_block = "172.168.4.0/22"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = false
  
}

resource "aws_internet_gateway" "net" {
    vpc_id = aws_vpc.vnet.id
  
}

resource "aws_route_table" "rt-pub" {
    vpc_id = aws_vpc.vnet.id

    route {
        gateway_id = aws_internet_gateway.net.id
        cidr_block = "0.0.0.0/0"
    }
}

resource "aws_route_table_association" "name" {
    subnet_id      = aws_subnet.public.id       # The ID of the subnet
    route_table_id = aws_route_table.rt-pub.id # The ID of the route table to associate with
}
resource "aws_eip" "dynamic" {
    domain = "vpc"
}
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.dynamic.id
    subnet_id = aws_subnet.private.id
}
resource "aws_route_table" "name" {
    vpc_id = aws_vpc.vnet.id
    route {
        nat_gateway_id = aws_nat_gateway.nat.id
        cidr_block = "0.0.0.0/0"
    }
  
}
resource "aws_route_table_association" "rt-private" {
    subnet_id      = aws_subnet.private.id      # The ID of the subnet
    route_table_id = aws_route_table.name.id # The ID of the route table to associate with
}
resource "aws_security_group" "ag" {
    name = "bg-b42"
    vpc_id = aws_vpc.vnet.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
   ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
}

resource "aws_instance" "web" {
    ami = "ami-0dee22c13ea7a9a67"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [ aws_security_group.ag.id ]
}

resource "aws_instance" "app" {
    ami = "ami-0dee22c13ea7a9a67"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private.id
    vpc_security_group_ids = [ aws_security_group.ag.id ]
}
