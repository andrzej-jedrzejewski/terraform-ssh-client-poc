resource "aws_instance" "backend_server" {
  count                  = length(var.backend_subnet_names)
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = module.private_subnets.subnet_ids[count.index]
  key_name               = aws_key_pair.backend_generated_key.key_name
  vpc_security_group_ids = [aws_security_group.backend-ssh.id]

  tags = merge(local.common_tags, {
    Name        = "BackendServer - ${count.index}",
    Environment = var.environment,
    Role        = "Backend - Linux server"
  })

  depends_on = [aws_security_group.backend-ssh]
}

resource "tls_private_key" "backend_private_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "backend_generated_key" {
  key_name   = var.backend_ssh_key_name
  public_key = tls_private_key.backend_private_ssh_key.public_key_openssh
}

resource "aws_security_group" "backend-ssh" {
  name        = "${var.environment}-ssh-to-backend-form-bastion"
  description = "SSH to Backend server"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.bastion.private_ip}/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}