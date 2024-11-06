module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = "dang-static-website"
  acl    = "public-read"

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_object" "index" {
  bucket = replace(module.s3_bucket.s3_bucket_arn, "arn:aws:s3:::", "")
  key    = "new_object_key"
  source = "${path.module}/index.html"
}

resource "aws_s3_object" "error" {
  bucket = replace(module.s3_bucket.s3_bucket_arn, "arn:aws:s3:::", "")
  key    = "new_object_key"
  source = "${path.module}/error.html"
}