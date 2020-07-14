# Pipeline para continous delivery de funciones Lambda
resource "aws_s3_bucket" "ShiftEmotionPipelinesLambda" {
    acl                     = "private"
    tags                    = {
        Project                = "Bucket para Code Build de proyecto de despliegue de AWS SAM"
    }
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

    depends_on = [
        aws_ecs_service.SpotifyAPI
    ]
}

#Pipeline para continous delivery de FrontEnd Web
resource "aws_s3_bucket" "ShiftEmotionPipelinesS3website" {
    acl                     = "private"
    tags                    = {
        Project                = "Bucket para Source de proyecto de despliegue de S3 static website"
    }
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
                BucketName      = aws_s3_bucket.ShiftEmotionFrontEndWeb.id
                Extract         = "true"
            }
            role_arn            = aws_iam_role.S3DeployRole.arn
        }
    }
}

#Pipeline para front end WebApp

resource "aws_s3_bucket" "ShiftEmotionPipelinesWebApp" {
    acl                     = "private"
    tags                    = {
        Project                = "Bucket para Code Build de proyecto de despliegue de AWS SAM"
    }
}

resource "aws_codebuild_project" "shiftemtion_react_project" {
    name                        = "shiftemtion_react_project"
    description                 = "Proyecto de compilación para FrontEnd WebApp"
    service_role                = aws_iam_role.WebAppBuildIAMRole.arn
    artifacts {
        type = "CODEPIPELINE"
    }
    environment {
        compute_type            = "BUILD_GENERAL1_SMALL"
        image                   = "aws/codebuild/standard:4.0"
        type                    = "LINUX_CONTAINER"
        environment_variable {
                name                = "BUCKET"
                value               = aws_s3_bucket.ShiftEmotionPipelinesWebApp.id
            }
        }

    source {
        type                    = "CODEPIPELINE"
    }

    depends_on                  = [
        aws_s3_bucket.ShiftEmotionPipelinesWebApp
    ]
}

resource "aws_codepipeline" "ShiftEmotionWebAppPipeline" {
    name                        = "ShiftEmotionWebAppPipeline"
    role_arn                    = aws_iam_role.WebAppPipelineIAMRole.arn
    artifact_store {
        location                = aws_s3_bucket.ShiftEmotionPipelinesWebApp.bucket
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
                Repo                = "shiftemotion-react-app"
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
                ProjectName     = "shiftemtion_react_project"
            }
        }
    }
}