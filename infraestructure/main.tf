resource "aws_s3_bucket" "ShiftEmotionFrontEndWeb" {
  bucket = "shiftemotionwebsite.com"
  acl    = "public-read"
  website {
    index_document = "login-page.html"
    }
}
  

resource "aws_s3_bucket_policy" "s3bucketpolicy" {
    bucket = aws_s3_bucket.ShiftEmotionFrontEndWeb.id

    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPerm",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::shiftemotionwebsite.com/*"
        }
    ]
}
    POLICY
}

resource "aws_s3_bucket" "ShiftEmotionImages" {
    acl                     = "private"
    tags                    = {
        Project                = "Bucket para almacenar las fotos de los usuarios"
    }
}

resource "aws_s3_bucket" "ShiftEmotionWebApp" {
  bucket = "shiftemotionwebapp.com"
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "index.html"
    }
}
  

resource "aws_s3_bucket_policy" "s3bucketpolicyWebApp" {
    bucket = aws_s3_bucket.ShiftEmotionWebApp.id

    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPerm",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::shiftemotionwebapp.com/*"
        }
    ]
}
    POLICY
}
