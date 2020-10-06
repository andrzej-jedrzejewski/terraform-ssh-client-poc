variable "regions_map" {
  type = map(string)
  default = {
    eu-central-1 = "euc1"
  }
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}
variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
}
variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "ssh_access_ip_range" {
  type    = list(string)
  default = ["89.67.119.107/32"]
}