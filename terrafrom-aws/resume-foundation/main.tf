# creating a VPC
resource "aws_vpc" "ravi-dev-vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "ravi-vpc"
  }
}

# create a subnet, so that EC2 is give the ip from this subnet, enable public ip so that can connect from internet
resource "aws_subnet" "ravi-dev-public-subnet" {
  vpc_id                  = aws_vpc.ravi-dev-vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "ravi-public-subnet"
  }
}

# create IG, to connect VPC
resource "aws_internet_gateway" "ravi-dev-igw" {
  vpc_id = aws_vpc.ravi-dev-vpc.id

  tags = {
    Name = "ravi-dev-igw"
  }
}

# create route table
resource "aws_route_table" "ravi-dev-rt" {
  vpc_id = aws_vpc.ravi-dev-vpc.id

  tags = {
    Name = "ravi-dev-public-rt"
  }
}

# create default internet open route
resource "aws_route" "default-route" {
  route_table_id         = aws_route_table.ravi-dev-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ravi-dev-igw.id
}

# create an association btw rt and subnet and as rt is already having igw and default route with cidr as 0.0.0.0/0. so that subnet will access to internet
resource "aws_route_table_association" "ravi-dev-rt-association-subnet" {
  subnet_id      = aws_subnet.ravi-dev-public-subnet.id
  route_table_id = aws_route_table.ravi-dev-rt.id
}

# create a sg and allow inboud traffic from your pc to sg and outbound traffic from sg to any ip on the open internet
resource "aws_security_group" "ravi-dev-sg" {
  name        = "ravi-dev-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.ravi-dev-vpc.id

  ingress {
    description = "connect from my PC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


# create keypair for ec2 #/home/ravi/.ssh/ravi-dev-ec2-key
resource "aws_key_pair" "ravi-dev-ec2-key" {
  key_name   = "ravi-dev-ec2-key"
  public_key = file("~/.ssh/ravi-dev-ec2-key.pub")
}


# create EC2
resource "aws_instance" "ravi-dev-ec2node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server-ami.id
  key_name               = aws_key_pair.ravi-dev-ec2-key.id
  vpc_security_group_ids = [aws_security_group.ravi-dev-sg.id]
  subnet_id              = aws_subnet.ravi-dev-public-subnet.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "ravi-dev-ec2node"
  }

  provisioner "local-exec" {
    command = templatefile("${var.os}-ssh-config.tpl", {
      hostname     = self.public_ip
      user         = "ubuntu"
      identityfile = "~/.ssh/ravi-dev-ec2-key"
    })
    interpreter = var.os == "linux" ? ["bash", "-c"] : ["Powershell", "-Command"]
  }
  
}




