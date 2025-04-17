terraform {
  backend "s3" {
    bucket = "bucket-homolog-devportal-veecode"
    key    = "hml-ec2-test/persistent.tfstate"
    region = "us-east-1"
  }
}