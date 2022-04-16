  output "ravi-dev-ec2node-public-ip" {
    value       = aws_instance.ravi-dev-ec2node.public_ip
    sensitive   = false
    description = "public ip address of the ec2"
    depends_on  = []
  }