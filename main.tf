resource "aws_vpc" "Prod-rock-VPC" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "Prod-rock-VPC"
  }
}



resource "aws_subnet" "Test-public-sub1" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.publicsub-1-cidr_block

  tags = {
    Name = "Test-public-sub1"
  }
}


resource "aws_subnet" "Test-public-sub2" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.publicsub-2-cidr_block

  tags = {
    Name = "Test-public-sub2"
  }
}


resource "aws_subnet" "Test-private-sub1" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.privatesub-1-cidr_block

  tags = {
    Name = "Test-private-sub1"
}
}


resource "aws_subnet" "Test-private-sub2" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = var.privatesub-2-cidr_block

  tags = {
    Name = "Test-private-sub2"
  }
}


resource "aws_route_table" "Test-pub-route-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  route = []
    

  tags = {
    Name = "Test-pub-route-table"
  }
}


resource "aws_route_table" "Test-priv-route-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  route {

    cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.Test-Nat-gateway.id
    
  }
}




resource "aws_route_table_association" "Pub-route-table-association1" {
  subnet_id      = aws_subnet.Test-public-sub1.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}


resource "aws_route_table_association" "Pub-route-table-association2" {
  subnet_id      = aws_subnet.Test-public-sub2.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}


resource "aws_route_table_association" "Priv-route-table-association1" {
  subnet_id      = aws_subnet.Test-private-sub1.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}


resource "aws_route_table_association" "Priv-route-table-association2" {
  subnet_id      = aws_subnet.Test-private-sub2.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}


resource "aws_internet_gateway" "Test-igw" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-igw"
  }
}


resource "aws_route" "Pub-Test-igw-route" {
  route_table_id            = aws_route_table.Test-pub-route-table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.Test-igw.id
} 


resource "aws_eip" "Test-Nat-gateway" {
  vpc      = true
}


resource "aws_nat_gateway" "Test-Nat-gateway" {
  allocation_id = aws_eip.Test-Nat-gateway.id
  subnet_id     = aws_subnet.Test-public-sub1.id

  tags = {
    Name = "Test-Nat-gateway"
  }
  
}



resource "aws_route_table" "test-Nat-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  route  {
    cidr_block = "0.0.0.0/0"

   nat_gateway_id = aws_nat_gateway.Test-Nat-gateway.id
   }

  }



resource "aws_security_group" "Test-sec-group" {
  name        = "Test-sec-group"
  description = "security group"

  vpc_id      = aws_vpc.Prod-rock-VPC.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }


  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["188.30.134.80/32"]
  }


egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Test-sec-group"
  }
}


resource "aws_instance" "Test-serve-1" {
  ami           = "ami-0f540e9f488cfa27d"
  key_name = "Dev-ops-key"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.Test-sec-group.id] 
  subnet_id      = aws_subnet.Test-public-sub1.id
  
  }


resource "aws_instance" "Test-serve-2" {
  ami           = "ami-0f540e9f488cfa27d"
  key_name = "Dev-ops-key"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.Test-sec-group.id] 
  subnet_id      = aws_subnet.Test-public-sub2.id
  
  }