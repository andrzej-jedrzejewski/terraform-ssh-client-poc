terraform {
  backend "s3" {
    bucket = "ajterraformbackend"
    key    = "dev/tfstate"
    region = "eu-central-1"
  }
}