provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
 bucket = aws_s3_bucket.my_bucket.id

 versioning_configuration {
   status = "Enabled"
 }
}
