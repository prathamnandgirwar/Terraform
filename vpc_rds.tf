
resource "aws_vpc" "vnet" {
    cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vnet.id
    cidr_block = "192.168.0.0/22"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
}
resource "aws_subnet" "public2" {
    vpc_id = aws_vpc.vnet.id
    cidr_block = "192.168.4.0/22"
    availability_zone = "ap-south-1b"
    map_public_ip_on_launch = true
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
resource "aws_route_table_association" "rt" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.rt-pub.id
}
resource "aws_security_group" "ag" {
    name = "bg-b41"
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

resource "aws_instance" "app" {
    ami = "ami-0dee22c13ea7a9a67"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [ aws_security_group.ag.id ]
  
}
resource "aws_db_instance" "RDS" {
    allocated_storage = 10
    db_name = "mydb"
    engine = "mysql"
    engine_version = "8.0"
    instance_class = "db.t3.micro"
    username = "pratham"
    password = "pratham123"
    skip_final_snapshot = true
}

resource "aws_db_subnet_group" "sb-grp" {
    name = "main"
    subnet_ids = [ aws_subnet.public.id, aws_subnet.public2.id ]
  
}
