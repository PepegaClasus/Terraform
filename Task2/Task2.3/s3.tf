# S3 bucket for website.
resource "aws_s3_bucket" "bucket" {
  bucket = "www.${var.bucket_name}"
  acl = "private"
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST", "PUT"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }
      policy = <<EOF
{
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2FYBUV1WGAV1E"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::www.${var.domain_name}/*"
        },
        {
            "Sid": "2",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2FYBUV1WGAV1E"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::www.${var.domain_name}/*"
        },
        {
            "Sid": "3",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2FYBUV1WGAV1E"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::www.${var.domain_name}/*"
        },
        {
            "Sid": "4",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E2FYBUV1WGAV1E"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::www.${var.domain_name}/*"
        }
    ]
}
EOF 

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

}