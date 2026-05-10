provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket       = "terraform-state-bucket306"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}