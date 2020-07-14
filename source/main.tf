module "shiftEmotionPermission" {
    source = "./permission"

    providers = {
        aws = aws
    }
}

module "shiftEmotionOregon" {
    source = "./infraestructure"

    providers = {
        aws = aws
    }

    LambdaBuildIAMRole_arn = module.shiftEmotionPermission.LambdaBuildIAMRole_arn
    LambdaPipelineIAMRole_arn = module.shiftEmotionPermission.LambdaPipelineIAMRole_arn
    LambdaDeployIAMRole_arn = module.shiftEmotionPermission.LambdaDeployIAMRole_arn
    ECRDockerBuildIAMRole_arn = module.shiftEmotionPermission.ECRDockerBuildIAMRole_arn
    ECRPipelineIAMRole_arn = module.shiftEmotionPermission.ECRPipelineIAMRole_arn
    ECRDeployIAMRole_arn = module.shiftEmotionPermission.ECRDeployIAMRole_arn
    S3PipelineRole_arn = module.shiftEmotionPermission.S3PipelineRole_arn
    S3DeployRole_arn = module.shiftEmotionPermission.S3DeployRole_arn
    WebAppBuildIAMRole_arn = module.shiftEmotionPermission.WebAppBuildIAMRole_arn
    WebAppPipelineIAMRole_arn = module.shiftEmotionPermission.WebAppPipelineIAMRole_arn
    WebAppDeployIAMRole_arn = module.shiftEmotionPermission.WebAppDeployIAMRole_arn
    shiftEmotionTaskRole_arn = module.shiftEmotionPermission.shiftEmotionTaskRole_arn

    LambdaBuildIAMRole_id = module.shiftEmotionPermission.LambdaBuildIAMRole_id
    LambdaPipelineIAMRole_id = module.shiftEmotionPermission.LambdaPipelineIAMRole_id
    LambdaDeployIAMRole_id = module.shiftEmotionPermission.LambdaDeployIAMRole_id
    ECRDockerBuildIAMRole_id = module.shiftEmotionPermission.ECRDockerBuildIAMRole_id
    ECRPipelineIAMRole_id = module.shiftEmotionPermission.ECRPipelineIAMRole_id
    ECRDeployIAMRole_id = module.shiftEmotionPermission.ECRDeployIAMRole_id
    S3PipelineRole_id = module.shiftEmotionPermission.S3PipelineRole_id
    S3DeployRole_id = module.shiftEmotionPermission.S3DeployRole_id
    WebAppBuildIAMRole_id = module.shiftEmotionPermission.WebAppBuildIAMRole_id
    WebAppPipelineIAMRole_id = module.shiftEmotionPermission.WebAppPipelineIAMRole_id
    WebAppDeployIAMRole_id = module.shiftEmotionPermission.WebAppDeployIAMRole_id
    shiftEmotionTaskRole_id = module.shiftEmotionPermission.shiftEmotionTaskRole_id
}

module "shiftEmotionVirginia" {
    source = "./infraestructure"

    providers = {
        aws = aws.us-east-1
    }

    LambdaBuildIAMRole_arn = module.shiftEmotionPermission.LambdaBuildIAMRole_arn
    LambdaPipelineIAMRole_arn = module.shiftEmotionPermission.LambdaPipelineIAMRole_arn
    LambdaDeployIAMRole_arn = module.shiftEmotionPermission.LambdaDeployIAMRole_arn
    ECRDockerBuildIAMRole_arn = module.shiftEmotionPermission.ECRDockerBuildIAMRole_arn
    ECRPipelineIAMRole_arn = module.shiftEmotionPermission.ECRPipelineIAMRole_arn
    ECRDeployIAMRole_arn = module.shiftEmotionPermission.ECRDeployIAMRole_arn
    S3PipelineRole_arn = module.shiftEmotionPermission.S3PipelineRole_arn
    S3DeployRole_arn = module.shiftEmotionPermission.S3DeployRole_arn
    WebAppBuildIAMRole_arn = module.shiftEmotionPermission.WebAppBuildIAMRole_arn
    WebAppPipelineIAMRole_arn = module.shiftEmotionPermission.WebAppPipelineIAMRole_arn
    WebAppDeployIAMRole_arn = module.shiftEmotionPermission.WebAppDeployIAMRole_arn
    shiftEmotionTaskRole_arn = module.shiftEmotionPermission.shiftEmotionTaskRole_arn

    LambdaBuildIAMRole_id = module.shiftEmotionPermission.LambdaBuildIAMRole_id
    LambdaPipelineIAMRole_id = module.shiftEmotionPermission.LambdaPipelineIAMRole_id
    LambdaDeployIAMRole_id = module.shiftEmotionPermission.LambdaDeployIAMRole_id
    ECRDockerBuildIAMRole_id = module.shiftEmotionPermission.ECRDockerBuildIAMRole_id
    ECRPipelineIAMRole_id = module.shiftEmotionPermission.ECRPipelineIAMRole_id
    ECRDeployIAMRole_id = module.shiftEmotionPermission.ECRDeployIAMRole_id
    S3PipelineRole_id = module.shiftEmotionPermission.S3PipelineRole_id
    S3DeployRole_id = module.shiftEmotionPermission.S3DeployRole_id
    WebAppBuildIAMRole_id = module.shiftEmotionPermission.WebAppBuildIAMRole_id
    WebAppPipelineIAMRole_id = module.shiftEmotionPermission.WebAppPipelineIAMRole_id
    WebAppDeployIAMRole_id = module.shiftEmotionPermission.WebAppDeployIAMRole_id
    shiftEmotionTaskRole_id = module.shiftEmotionPermission.shiftEmotionTaskRole_id
}