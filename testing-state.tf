terraform {
  backend "s3" {
    bucket = "tfstate-for-demo-projects"
    region = "us-east-1"
    key    = "testing"
  }
}