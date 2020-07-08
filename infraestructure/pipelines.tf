# Pipeline para continous delivery de funciones Lambda
resource "aws_s3_bucket" "ShiftEmotionPipelinesLambda" {
    bucket                  = "codebuildshiftemotiontest"
    acl                     = "private"
    tags                    = {
        Name                = "codebuildshiftemotiontest"
    }
}

resource "aws_iam_role" "LambdaBuildIAMRole" {
    name                    = "LambdaBuildIAMRole"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
    EOF
}

resource "aws_iam_role_policy" "LambdaBuildIAMPolicy" {
    role                        = aws_iam_role.LambdaBuildIAMRole.name
    policy                      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "S3:*"
            ]
        }
    ]
}
    POLICY
}

resource "aws_codebuild_project" "shiftemtion_sam_project" {
    name                        = "shiftemtion_sam_project"
    description                 = "Proyecto de compilación para proyecto en AWS SAM"
    service_role                = aws_iam_role.LambdaBuildIAMRole.arn
    artifacts {
        type = "NO_ARTIFACTS"
    }
    environment {
        compute_type            = "BUILD_GENERAL1_SMALL"
        image                   = "aws/codebuild/standard:4.0"
        type                    = "LINUX_CONTAINER"
    }

    source {
        type                    = "CODEPIPELINE"
    }

    depends_on                  = [
        aws_s3_bucket.ShiftEmotionPipelinesLambda
    ]
}

resource "aws_iam_role" "LambdaPipelineIAMRole" {
    name                        = "LambdaPipelineIAMRole"
    assume_role_policy          = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
            "Service": "codepipeline.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
    EOF
}

resource "aws_iam_role_policy" "LambdaPipelineIAMPolicy" {
    name                        = "LambdaPipelineIAMPolicy"
    role                        = aws_iam_role.LambdaPipelineIAMRole.id
    policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "cloudformation.amazonaws.com",
                        "elasticbeanstalk.amazonaws.com",
                        "ec2.amazonaws.com",
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Action": [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "elasticbeanstalk:*",
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "rds:*",
                "sqs:*",
                "ecs:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
                "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "opsworks:CreateDeployment",
                "opsworks:DescribeApps",
                "opsworks:DescribeCommands",
                "opsworks:DescribeDeployments",
                "opsworks:DescribeInstances",
                "opsworks:DescribeStacks",
                "opsworks:UpdateApp",
                "opsworks:UpdateStack"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:CreateChangeSet",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "devicefarm:ListProjects",
                "devicefarm:ListDevicePools",
                "devicefarm:GetRun",
                "devicefarm:GetUpload",
                "devicefarm:CreateUpload",
                "devicefarm:ScheduleRun"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:CreateProvisioningArtifact",
                "servicecatalog:DescribeProvisioningArtifact",
                "servicecatalog:DeleteProvisioningArtifact",
                "servicecatalog:UpdateProduct"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImages"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:DescribeStateMachine",
                "states:StartExecution"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "appconfig:StartDeployment",
                "appconfig:StopDeployment",
                "appconfig:GetDeployment"
            ],
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
    EOF
}

resource "aws_codepipeline" "ShiftEmotionLambdaPipeline" {
    name                        = "ShiftEmotionLambdaPipeline"
    role_arn                    = aws_iam_role.LambdaPipelineIAMRole.arn
    artifact_store {
        location                = aws_s3_bucket.ShiftEmotionPipelinesLambda.bucket
        type                    = "S3"
    }

    stage {
        name                    = "Source"
        action {
            name                    = "Source"
            category                = "Source"
            owner                   = "ThirdParty"
            provider                = "GitHub"
            version                 = "1"
            output_artifacts        = [
                "SourceArtifact"
            ]
            configuration           = {
                Owner               = "EzioAARM"
                Repo                = "shiftemotion-backend"
                Branch              = "master"
            }
        }
    }

    stage {
        name                    = "Build"
        action {
            name                = "Build"
            category            = "Build"
            owner               = "AWS"
            provider            = "CodeBuild"
            version             = "1"
            input_artifacts     = [
                "SourceArtifact"
            ]
            output_artifacts    = [
                "BuildArtifact"
            ]
            configuration       = {
                ProjectName     = "shiftemtion_sam_project"
            }
        }
    }

    stage {
        name                    = "Deploy"
        action {
            name                = "Deploy"
            category            = "Deploy"
            owner               = "AWS"
            provider            = "CloudFormation"
            input_artifacts     = [
                "BuildArtifact"
            ]
            version             = "1"
            configuration       = {
                ActionMode      = "CHANGE_SET_REPLACE"
                Capabilities    = "CAPABILITY_IAM,CAPABILITY_AUTO_EXPAND"
                StackName       = "shiftemotion-lambda-backend"
                TemplatePath    = "BuildArtifact::outputtemplate.yml"
            }
        }
    }

    stage {
        name                    = "DeployChangeSet"
        action {
            name                = "DeployChangeSet"
            category            = "Deploy"
            owner               = "AWS"
            provider            = "CloudFormation"
            input_artifacts     = [
                "BuildArtifact"
            ]
            version             = "1"
            configuration       = {
                ActionMode      = "CHANGE_SET_EXECUTE"
                StackName       = "shiftemotion-lambda-backend"
                ChangeSetName   = "shiftemotion-lambda-backend-changeset"
            }
        }
    }
}

#Pipeline para continous delivery del servicio en Fargate