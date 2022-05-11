provider "aws"{
    region = "us-east-1"
}

resource "aws_cloudfront_distribution" "cloudfront" {
    origin {
        domain_name = "indexstaticsite.s3.us-east-1.amazonaws.com"
        origin_id = "s3://indexstaticsite/index.html"
        s3_origin_config {
            origin_access_identity = "origin-access-identity/cloudfront/E2FYBUV1WGAV1E"
    }
    }
    
    default_root_object = "static.html"
    enabled = true
   
    custom_error_response {
        error_caching_min_ttl = 3000
        error_code = 404
        response_code = 200
        response_page_path = "/index.html"
    }
    default_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = "s3://indexstaticsite/index.html"
        
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
    
    price_class = "PriceClass_100"
    
    restrictions {
        geo_restriction {
            
            restriction_type = "none"
        }
    }
    
    viewer_certificate {
        cloudfront_default_certificate = true
    }
}


