output "bastion_public_ip" {
  value = aws_eip.bastion_ip.public_ip
}

output "bastion_private_ssh_key" {
  value = tls_private_key.backend_private_ssh_key.private_key_pem
}

output "backend_servers_private_ip" {
  value = aws_instance.backend_server.*.private_ip
}