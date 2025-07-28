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

resource "aws_s3_bucket_policy" "user_access_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowUserReadWriteAccess",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::851725195108:user/practice-user"  # ✅ Make sure this is exact ARN
        },
        Action    = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource  = "${aws_s3_bucket.my_bucket.arn}/*",
      },
      {
        Sid = "AllowUserListbucket",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::851725195108:user/practice-user"
        },
        Action = "s3:ListBucket",
        Resource = aws_s3_bucket.my_bucket.arn
      }
    ]
  })
}
