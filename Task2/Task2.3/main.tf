provider "aws"{
    region = "us-east-1"
}


resource "aws_cloudfront_distribution" "prod_distribution" {
    origin {
        domain_name = "www.${var.bucket_name}.s3.us-east-1.amazonaws.com"
        origin_id = "s3://www.${var.bucket_name}/index.html"
        s3_origin_config {
            origin_access_identity = "origin-access-identity/cloudfront/E2FYBUV1WGAV1E"
    }
    }
    # By default, show index.html file
    default_root_object = "index.html"
    enabled = true
    # If there is a 404, return index.html with a HTTP 200 Response
    custom_error_response {
        error_caching_min_ttl = 3000
        error_code = 404
        response_code = 200
        response_page_path = "/index.html"
    }
    default_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = "s3://www.${var.bucket_name}/index.html"
        # Forward all query strings, cookies and headers
        forwarded_values {
        query_string = false
        cookies {
            forward = "none"
        }
        }
        viewer_protocol_policy = "allow-all"
        min_ttl = 0
        default_ttl = 3600
        max_ttl = 86400
    }
    # Distributes content to US and Europe
    price_class = "PriceClass_100"
    # Restricts who is able to access this content
    restrictions {
        geo_restriction {
            # type of restriction, blacklist, whitelist or none
            restriction_type = "none"
        }
    }
    # SSL certificate for the service.
    viewer_certificate {
        cloudfront_default_certificate = true
    }
}
