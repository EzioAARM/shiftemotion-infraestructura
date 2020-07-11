# Pipeline para continous delivery de funciones Lambda
resource "aws_s3_bucket" "ShiftEmotionPipelinesLambda" {
    acl                     = "private"
    tags                    = {
        Project                = "Bucket para Code Build de proyecto de despliegue de AWS SAM"
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
        type = "CODEPIPELINE"
    }
    environment {
        compute_type            = "BUILD_GENERAL1_SMALL"
        image                   = "aws/codebuild/standard:4.0"
        type                    = "LINUX_CONTAINER"
        environment_variable {
            name                = "BUCKET"
            value               = aws_s3_bucket.ShiftEmotionPipelinesLambda.id
        }
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
    policy                      = <<EOF
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

resource "aws_iam_role" "LambdaDeployIAMRole" {
    name                        = "LambdaDeployIAMRole"
    assume_role_policy          = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "cloudformation.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codepipeline.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.LambdaPipelineIAMRole.arn}"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
    EOF
}

resource "aws_iam_role_policy" "LambdaDeployIAMPolicy" {
    name                        = "LambdaDeployIAMPolicy"
    role                        = aws_iam_role.LambdaDeployIAMRole.id
    policy                      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:*"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Action": [
                "apigateway:*",
                "codedeploy:*",
                "lambda:*",
                "cloudformation:CreateChangeSet",
                "iam:GetRole",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:PutRolePolicy",
                "iam:AttachRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:DetachRolePolicy",
                "iam:PassRole",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketVersioning",
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
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
                OAuthToken          = var.GithubToken
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
            run_order           = 1
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
                ChangeSetName   = "shiftemotion-lambda-backend-changeset"
                RoleArn         = aws_iam_role.LambdaDeployIAMRole.arn
            }
            role_arn            = aws_iam_role.LambdaDeployIAMRole.arn
        }

        action {
            run_order           = 2
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

#Pipeline para continous delivery de la imagen de Docker en ECR

resource "aws_s3_bucket" "ShiftEmotionPipelinesECR" {
    acl                     = "private"
    tags                    = {
        Project                = "Bucket para Code Build de proyecto de despliegue de imagen ECR"
    }
}

resource "aws_iam_role" "ECRDockerBuildIAMRole" {
    name                        = "ECRDockerBuildIAMRole"
    assume_role_policy          = <<EOF
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

resource "aws_iam_role" "ECRPipelineIAMRole" {
    name                        = "ECRPipelineIAMRole"
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

resource "aws_iam_role_policy" "ECRPipelineIAMPolicy" {
    name                        = "ECRPipelineIAMPolicy"
    role                        = aws_iam_role.ECRPipelineIAMRole.id
    policy                      = <<EOF
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

resource "aws_iam_role" "ECRDeployIAMRole" {
    name                        = "ECRDeployIAMRole"
    assume_role_policy          = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "cloudformation.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codepipeline.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.ECRPipelineIAMRole.arn}"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
    EOF
}

resource "aws_iam_role_policy" "ECRDockerBuildPolicy"{
    role                        = aws_iam_role.ECRDockerBuildIAMRole.name
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
                "S3:*",
                "ECR:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::*"
        }
    ]
}
    POLICY
}

resource "aws_iam_role_policy" "ECRDeployIAMPolicy" {
    name                        = "ECRDeployIAMPolicy"
    role                        = aws_iam_role.ECRDeployIAMRole.id
    policy                      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:*"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "${aws_s3_bucket.ShiftEmotionPipelinesECR.arn}"
        },
        {
            "Action": [
                "apigateway:*",
                "codedeploy:*",
                "lambda:*",
                "cloudformation:CreateChangeSet",
                "iam:GetRole",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:PutRolePolicy",
                "iam:AttachRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:DetachRolePolicy",
                "iam:PassRole",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketVersioning",
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate",
                "ecs:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
    EOF
}

resource "aws_codebuild_project" "shiftemotion_docker_project" {
    name                        = "shiftemotion_docker_project"
    description                 = "Proyecto de compilacion para proyecto en ECR"
    service_role                = aws_iam_role.ECRDockerBuildIAMRole.arn 
    artifacts {
        type = "CODEPIPELINE"
    }
    environment {
        compute_type            = "BUILD_GENERAL1_SMALL"
        image                   = "aws/codebuild/standard:4.0"
        type                    = "LINUX_CONTAINER"
        privileged_mode         = "true"
        environment_variable {
            name                = "BUCKET"
            value               = aws_s3_bucket.ShiftEmotionPipelinesECR.id 
        }

        environment_variable {
            name                = "AWS_ACCOUNT_ID"
            value               = var.AccountId
        }

        environment_variable {
            name                = "IMAGE_REPO_NAME"
            value               = "shiftemotionspotify"
        }

        environment_variable {
            name                = "IMAGE_TAG"
            value               = "latest"
        }

        environment_variable {
            name                = "REPO_URI"
            value               = aws_ecr_repository.shiftEmotion.repository_url
        }
    }

    source {
        type                    = "CODEPIPELINE"
    }

    depends_on                  = [
        aws_s3_bucket.ShiftEmotionPipelinesECR
    ]
}

resource "aws_codepipeline" "ShiftEmotionECRPipeLine" {
    name                        = "ShiftEmotionECRPipeLine"
    role_arn                    = aws_iam_role.ECRPipelineIAMRole.arn
    artifact_store {
        location                = aws_s3_bucket.ShiftEmotionPipelinesECR.bucket
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
                Repo                = "shiftemotion-spotify-integration"
                Branch              = "master"
                OAuthToken          = var.GithubToken
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
                ProjectName     = "shiftemotion_docker_project"
            }
        }
    }

    stage {
        name                    = "Deploy"
        action {
            run_order           = 1
            name                = "Deploy"
            category            = "Deploy"
            owner               = "AWS"
            provider            = "ECS"
            input_artifacts     = [
                "BuildArtifact"
            ]
            version             = "1"
            configuration       = {
                ClusterName     = "ShiftEmotionSpotifyCluster"
                ServiceName     = "SpotifyAPI"
            }
            role_arn            = aws_iam_role.ECRDeployIAMRole.arn
        }
    }
}

#Pipeline para continous delivery de FrontEnd Web
resource "aws_s3_bucket" "ShiftEmotionPipelinesS3website" {
    acl                     = "private"
    tags                    = {
        Project                = "Bucket para Source de proyecto de despliegue de S3 static website"
    }
}

resource "aws_iam_role" "S3PipelineRole" {
    name                    = "S3PipelineRole"
    assume_role_policy = <<EOF
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

resource "aws_iam_role_policy" "S3PipelineRolePolicy" {
    role = aws_iam_role.S3PipelineRole.id
    policy = <<POLICY
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
    POLICY
}

resource "aws_iam_role" "S3DeployRole" {
    name                        = "S3DeployRole"
    assume_role_policy          = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "cloudformation.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codepipeline.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.S3PipelineRole.arn}"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
    EOF
}

resource "aws_iam_role_policy" "S3DeployRolePolicy" {
    name                        = "S3DeployRolePolicy"
    role                        = aws_iam_role.S3DeployRole.id
    policy                      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:*"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Action": [
                "apigateway:*",
                "codedeploy:*",
                "lambda:*",
                "cloudformation:CreateChangeSet",
                "iam:GetRole",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:PutRolePolicy",
                "iam:AttachRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:DetachRolePolicy",
                "iam:PassRole",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketVersioning",
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
    EOF
}

resource "aws_codepipeline" "ShiftEmotionFrontEndPipeLine" {
    name                        = "ShiftEmotionFrontEndPipeLine"
    role_arn                    = aws_iam_role.S3PipelineRole.arn
    artifact_store {
        location                = aws_s3_bucket.ShiftEmotionPipelinesS3website.bucket
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
                Repo                = "shiftemotion-frontend-web"
                Branch              = "master"
                OAuthToken          = var.GithubToken
            }
        }
    }

    stage {
        name                    = "Deploy"
        action {
            run_order           = 1
            name                = "Deploy"
            category            = "Deploy"
            owner               = "AWS"
            provider            = "S3"
            input_artifacts     = [
                "SourceArtifact"
            ]
            version             = "1"
            configuration       = {
                BucketName      = "shiftemotionwebsite.com"
                Extract         = "true"
            }
            role_arn            = aws_iam_role.S3DeployRole.arn
        }
    }
}
