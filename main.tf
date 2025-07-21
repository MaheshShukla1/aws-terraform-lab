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

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.bucket_name}-logs"
  force_destroy = true  
}

resource "aws_s3_bucket_logging" "my_bucket_logging" {
  bucket = aws_s3_bucket.my_bucket.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_public_access_block" "my_bucket_block" {
  bucket = aws_s3_bucket.log_bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true 
  restrict_public_buckets = true
}