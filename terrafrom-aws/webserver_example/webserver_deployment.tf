# 1. Create vpc
# 2. Create Internet Gateway
# 3. Create Custom Route Table
# 4. Create a Subnet 
# 5. Associate subnet with Route Table
# 6. Create Security Group to allow port 22,80,443
# 7. Create a network interface with an ip in the subnet that was created in step 4
# 8. Assign an elastic IP to the network interface created in step 7
# 9. Create Ubuntu server and install/enable apache2


resource "aws_vpc" "vpc_ws" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "ravi_vpc_test"
  }
}

resource "aws_internet_gateway" "gw_ws" {
  vpc_id = aws_vpc.vpc_ws.id
  tags = {
    Name = "ravi_gw_test"
  }
}

resource "aws_route_table" "route_table_ws" {
  vpc_id = aws_vpc.vpc_ws.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw_ws.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw_ws.id
  }

  tags = {
    Name = "ravi_route_table_testing"
  }
}

resource "aws_subnet" "subnet_ws" {
  vpc_id            = aws_vpc.vpc_ws.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "ravi_subnet_testing"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_ws.id
  route_table_id = aws_route_table.route_table_ws.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.vpc_ws.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
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
    Name = "allow_web"
  }
}

resource "aws_network_interface" "nic_ws" {
  subnet_id       = aws_subnet.subnet_ws.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}


resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.nic_ws.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.gw_ws]
}

resource "aws_instance" "ec2_ws" {
  ami               = "ami-0c02fb55956c7d316"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = "terraform_testing_ravi"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.nic_ws.id
  }

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                sudo bash -c 'echo your very first web server > /var/www/html/index.html'
                EOF
  tags = {
    Name = "ravi_ec2_terraform_testing"
  }
}
