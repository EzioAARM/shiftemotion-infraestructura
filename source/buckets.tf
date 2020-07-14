resource "aws_s3_bucket" "ShiftEmotionImages" {
    #bucket                  = "shift-emotion-images"
    acl                     = "private"
    region                  = var.regionPrincipal
    tags                    = {
        Name                   = "shift-emotion-images"
        Project                = "Bucket para almacenar las fotos de los usuarios"
    }

    versioning {
        enabled = true
        }

    replication_configuration {
        role = aws_iam_role.RoleImagesReplicaS3.arn 
        rules {
            id = "replicacion"
            status = "Enabled"
            destination {
                bucket = aws_s3_bucket.ShiftEmotionImagesReplication.arn 
            }
        }
    }  
}

resource "aws_iam_role" "RoleImagesReplicaS3" {
  name = "RoleImagesReplicaS3"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "PolicyImagesReplicaS3" {
  name = "PolicyImagesReplicaS3"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.ShiftEmotionImages.arn}"
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.ShiftEmotionImages.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.ShiftEmotionImagesReplication.arn}/*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "PolicyAttachmentImagesReplicaS3" {
  role       = aws_iam_role.RoleImagesReplicaS3.name
  policy_arn = aws_iam_policy.PolicyImagesReplicaS3.arn
}

resource "aws_s3_bucket" "ShiftEmotionImagesReplication" {
    #bucket                  = "shift-emotion-images-replication"
    acl                     = "private"
    region                  = var.regionSecundaria
    provider                = aws.us-east-1
    tags                    = {
        Name                   = "shift-emotion-images-replication"
        Project                = "Bucket para la replicacion las fotos de los usuarios"
    }

    versioning {
        enabled = true
        }
}