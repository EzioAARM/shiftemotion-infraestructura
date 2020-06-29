module "shiftEmotionDatabase" {
    source = "./database"
}

module "shiftEmotionPermission" {
    source = "./permission"

    providers = {
        aws = aws
    }
}

module "shiftEmotionRegion1" {
    source = "./source"

    providers = {
        aws = aws
    }

    lambda_policy_arn = module.shiftEmotionPermission.lambda_policy_arn
}

module "shiftEmotionRegion2" {
    source = "./source"

    providers = {
        aws = aws.us-west-2
    }
    
    lambda_policy_arn = module.shiftEmotionPermission.lambda_policy_arn
}