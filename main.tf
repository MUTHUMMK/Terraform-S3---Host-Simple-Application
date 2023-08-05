#f irst create bucket with variable


resource "aws_s3_bucket" "mys3" {
    bucket = var.bucketname
}
#Enable ownership ON
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = var.bucketname

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Enable Public Access

resource "aws_s3_bucket_public_access_block" "mmk" {
  bucket = var.bucketname

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Enable Versioning

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = var.bucketname
  versioning_configuration {
    status = "Enabled"
  }
}

# acl- access control list - public-read

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.mmk,
  ]

  bucket = var.bucketname
  acl    = "public-read"
}

# object upload in your bucket

resource "aws_s3_object" "index" {
  bucket = var.bucketname
  key    = "index.html"
  source = "index.html"
  acl    = "public-read"
  content_type = "html"
  
}
resource "aws_s3_object" "error" {

  bucket = var.bucketname
  key    = "error.html"
  source = "error.html"
  acl    = "public-read"
  content_type = "html"
  
}

# Enable web hosting & configuration

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = var.bucketname

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.example]
}





