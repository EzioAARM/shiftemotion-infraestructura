variable "bucketImagenes" {
    type = string
    default = "terraform-20200714055831705400000001"
}

resource "aws_s3_bucket" "ShiftEmotionFrontEndWeb" {
  #bucket = "shiftemotionwebsite.com"
  acl    = "public-read"
  website {
    index_document = "login-page.html"
    }
}

resource "aws_s3_bucket" "ShiftEmotionWebApp" {
  #bucket = "shiftemotionwebapp.com"
  acl    = "public-read"
  website {
    index_document = "index.html"
    error_document = "index.html"
    }
}