terraform {
  backend "s3" {
    bucket = "acs-730-final-group1-bucket"
    key    = "prod/webserver/terraform.tfstate"
    region = "us-east-1"
  }
}