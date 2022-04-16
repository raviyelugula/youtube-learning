# A query of the AWS API to receive info we need to deploy. In our case we need ec2's ami and owner info.

data "aws_ami" "server-ami" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

}


