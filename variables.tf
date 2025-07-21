variable "aws_region" {
  description = "Aws region to create s3 bucket in"
  type = string
  default = "ap-south-1"
}

variable "bucket_name" {
  description = "Name of the s3 bucket"
  type = string
}