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

    task_policy_arn = module.shiftEmotionPermission.task_definition_role_arn
}

module "shiftEmotionRegion2" {
    source = "./source"

    providers = {
        aws = aws.us-west-2
    }

    task_policy_arn = module.shiftEmotionPermission.task_definition_role_arn
}