
resource "aws_default_vpc" "default_my3vpc" {

  tags = {
    Name = "default my3vpc"
  }
}

data "aws_availability_zones" "available_zones" {}

resource "aws_default_subnet" "default_my1subnet" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags = {
    Name = "default my3subnet"
  }
}

resource "aws_security_group" "new_security_group4" {
  name        = "new_security_group3"
  description = "Security group for EC2"
  vpc_id      = aws_default_vpc.default_my3vpc.id

  ingress {
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
}


resource "aws_instance" "My_instance" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t2.micro"
  key_name               = "one_key"
  vpc_security_group_ids = [aws_security_group.new_security_group4.id]

  tags = {
    Name = "My_instance"
  }

  user_data = file("install-jenkins.sh")
}

#output "website_url" {
 # value     = join ("", ["http://", aws_instance.myNew_instance.public_dns, ":", "8080"])
#}

