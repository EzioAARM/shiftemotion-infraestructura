module "shiftEmotionPermission" {
    source = "./permission"

    providers = {
        aws = aws
    }
}

