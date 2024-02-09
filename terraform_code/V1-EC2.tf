provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "demo-server" {
    ami = "ami-0449c34f967dbf18a"
    instance_type = "t2.micro"
    key_name = "dpp"
  
}