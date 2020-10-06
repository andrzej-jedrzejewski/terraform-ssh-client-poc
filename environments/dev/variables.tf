variable "region" {
  default = "eu-central-1"
}

variable "environment" {
  default = "dev"
}

variable "namespace" {
  default = "backend"
}

variable "bastion_ssh_key_name" {
  default = "bastion-ssh-key"
}

variable "backend_ssh_key_name" {
  default = "backend-ssh-key"
}

variable "backend_subnet_names" {
  type    = list(string)
  default = ["server1", "server2", "server3"]
}
