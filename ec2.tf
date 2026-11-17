# key-pair(login)
resource "aws_key_pair" "my-key" {
  key_name   = "terra-ec2-key"
  public_key = file("terra-ec2-key.pub")
}

# VPC & security group
resource "aws_default_vpc" "default"{

}

resource "aws_security_group" "my_security-group" {
    name = "automate-sg-new"
    description = "this will add a TF generated Security group" 
    vpc_id = aws_default_vpc.default.id #interpolation
    # inbound rules
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow SSH"
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP"
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS"
    }
    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Flask App"
    }
    # outbound rules
    egress{
        from_port = 0
        to_port = 0
        protocol = "-1" # -1 is use for all access
        cidr_blocks = ["0.0.0.0/0"]
        description = "All access open"
    }
     tags = {
    Name = "automate-sg"
  }
}


# ec2 instance 
resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my-key.key_name
    security_groups = [aws_security_group.my_security-group.name]
    ami = var.ec2_ami_id # Ubuntu
    instance_type = var.ec2_instance_type
    root_block_device {
        volume_size = var.ec2_root_storage_size
        volume_type = "gp3"
    }
    tags = {
        Name = "Automated-EC2"
    }
}