provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.aws_vpc_cidr
  tags = { Name = "MY_PERSONAL_VPC"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.aws_sub_pub1
  map_public_ip_on_launch = true
  tags = { Name = "My_public_subnet-1"
  }
}


resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.aws_sub_pub2
  map_public_ip_on_launch = true
  tags = { Name = "My_public_subnet-2"
  }
}
resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.aws_sub_pri1
  tags = { Name = "My_private_subnet-1"
  }
}
resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.aws_sub_pri2
  tags = { Name = "My_private_subnet-2"
  }
}
resource "aws_internet_gateway" "aws_ig" {
  vpc_id = aws_vpc.my_vpc.id
  tags = { Name = "My_IGW"
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.my_vpc.id
  tags = { Name = "My_Public_Route_table"
  }
}

resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.my_vpc.id
  tags = { Name = "My_Private_Route_table"
  }
}
resource "aws_route_table_association" "public_route_association1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public_route_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private_route_association1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_route_association2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_eip" "my_eip" {
  domain = "vpc"
  tags = { Name = "My_Elastic_IP"
  }
}

resource "aws_nat_gateway" "My_NAT_GW" {
  allocation_id = aws_eip.my_eip.id
  subnet_id     = aws_subnet.public_subnet1.id
  tags = { Name = "My_NAT_GATEWAY"
  }
}


resource "aws_route" "public_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public_route.id
  gateway_id             = aws_internet_gateway.aws_ig.id
}


resource "aws_route" "private_route" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private_route.id
  nat_gateway_id         = aws_nat_gateway.My_NAT_GW.id
}


resource "aws_security_group" "aws_sg" {
  vpc_id = aws_vpc.my_vpc.id
  tags = { Name = "My_Project_Security_Group"
  }

  ingress {
    description = "Allow HTTP Rules"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS Rules"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "Allow SSH Rules"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Jenkins to launch on website"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance_Creation" {
  instance_type               = var.aws_instance_type
  ami                         = var.aws_ami
  subnet_id                   = aws_subnet.public_subnet1.id
  key_name                    = aws_key_pair.my_key_pair.key_name
  associate_public_ip_address = true
  tags = { Name = "My_Project_Server"
  }
}

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my_key_pair_from_terraform"
  public_key = tls_private_key.my_key.public_key_openssh
}

output "private_key_pem" {
  value     = tls_private_key.my_key.private_key_pem
  sensitive = true
}
