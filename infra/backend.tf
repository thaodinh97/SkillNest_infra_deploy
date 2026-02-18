terraform {
  backend "s3" {
    bucket = "skillnest-action-tdinh"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}