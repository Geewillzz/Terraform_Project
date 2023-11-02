resource "aws_s3_bucket" "sample" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "sample" {
  bucket = aws_s3_bucket.sample.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "sample" {
  bucket = aws_s3_bucket.sample.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "sample" {
  depends_on = [
    aws_s3_bucket_ownership_controls.sample,
    aws_s3_bucket_public_access_block.sample,
  ]

  bucket = aws_s3_bucket.sample.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket  = aws_s3_bucket.sample.id
  key     = "index.html"
  source  = "index.html"
  acl     = "public-read"
  content_type  = "text/html"
}

resource "aws_s3_object" "error" {
  bucket  = aws_s3_bucket.sample.id
  key     = "error.html"
  source  = "error.html"
  acl     = "public-read"
  content_type  = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket  = aws_s3_bucket.sample.id
  key     = "profile.png"
  source  = "profile.png"
  acl     = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket   = aws_s3_bucket.sample.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  
  depends_on = [ aws_s3_bucket_acl.sample ]
}
