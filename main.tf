data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-tomcat-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_vpc" "new_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "new_vpc"
  }
}

resource "aws_subnet" "new_subnet" {
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "new_subnet"
  }
}

resource "aws_instance" "blog" {
  ami                   = data.aws_ami.app_ami.id
  instance_type         = var.instance_type
  subnet_id             = data.aws_vpc.default.id
  vpc_security_group_ids = [aws_security_group.blog.id]

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_instance" "new_blog1" {
  ami                   = data.aws_ami.app_ami.id
  instance_type         = var.instance_type
  subnet_id             = aws_subnet.new_subnet.id
  vpc_security_group_ids = [aws_security_group.new_blog.id]

  tags = {
    Name = "new_blog1"
  }
}

resource "aws_instance" "new_blog2" {
  ami                   = data.aws_ami.app_ami.id
  instance_type         = var.instance_type
  subnet_id             = aws_subnet.new_subnet.id
  vpc_security_group_ids = [aws_security_group.new_blog.id]

  tags = {
    Name = "new_blog2"
  }
}

resource "aws_security_group" "blog" {
  name        = "blog"
  description = "Allow http, https, and ICMP in. Allow everything out"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "new_blog" {
  name        = "new_blog"
  description = "Allow http, https, and ICMP in. Allow everything out"
  vpc_id      = aws_vpc.new_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
