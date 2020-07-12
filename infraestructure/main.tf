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
