module "shiftEmotionRegion1" {
    source = "./source"

    providers = {
        aws = aws
    }
}

module "shiftEmotionRegion2" {
    source = "./source"

    providers = {
        aws = aws.us-west-2
    }
}