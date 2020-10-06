data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = module.public_subnets.subnet_ids[0]
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.bastion-ssh.id]

  tags = merge(local.common_tags, {
    Name        = "Bastion",
    Environment = var.environment,
    Role        = "Bation - Linux server"
  })

  depends_on = [aws_security_group.bastion-ssh]
}

resource "aws_eip" "bastion_ip" {
  vpc = true
}

resource "aws_eip_association" "bastion_ip_assoc" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion_ip.id
}

resource "tls_private_key" "bastion_private_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.bastion_ssh_key_name
  public_key = tls_private_key.bastion_private_ssh_key.public_key_openssh
}

resource "aws_security_group" "bastion-ssh" {
  name        = "${var.environment}-ssh-to-bastion-form-outside"
  description = "SSH to Bastion server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_access_ip_range
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}