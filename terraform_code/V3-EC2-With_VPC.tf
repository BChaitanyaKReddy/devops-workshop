provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-0449c34f967dbf18a"
    instance_type = "t2.micro"
    key_name = "dpp"
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.public-subnet-01.id
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "Allow ssh inbound traffic"
  vpc_id = aws_vpc.demo-vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Demo-sg"
  }
}
resource "aws_vpc" "demo-vpc" {
  cidr_block       = "10.1.0.0/16"

  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_subnet" "public-subnet-01" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public-subnet-01"
  }
}

resource "aws_subnet" "public-subnet-02" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "public-subnet-02"
  }
}


resource "aws_internet_gateway" "demo-gw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-gw"
  }
}


resource "aws_route_table" "demo-rt" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-gw.id
  }

 tags = {
    Name = "demo-rt"
  }

}

resource "aws_route_table_association" "demo-rt-assoc-subnet-01" {
  subnet_id      = aws_subnet.public-subnet-01.id
  route_table_id = aws_route_table.demo-rt.id
}

resource "aws_route_table_association" "demo-rt-assoc-subnet-02" {
  subnet_id      = aws_subnet.public-subnet-02.id
  route_table_id = aws_route_table.demo-rt.id
}

