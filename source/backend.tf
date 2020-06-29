#Funciones lambda
resource "aws_lambda_function" "jwtValidation" {
    filename                = "./lambda/main.zip"
    function_name           = "jwtValidation"
    role                    = var.lambda_policy_arn
    handler                 = "main"
    runtime                 = "go1.x"
    vpc_config {
        subnet_ids          = [
            aws_subnet.private.id
        ]
        security_group_ids  = [
            aws_security_group.sg_global.id
        ]
    }
}

resource "aws_lambda_function" "login" {
    filename                = "./lambda/main.zip"
    function_name           = "login"
    role                    = var.lambda_policy_arn
    handler                 = "main"
    runtime                 = "go1.x"
    vpc_config {
        subnet_ids          = [
            aws_subnet.private.id
        ]
        security_group_ids  = [
            aws_security_group.sg_global.id
        ]
    }
}

resource "aws_lambda_function" "generarToken" {
    filename                = "./lambda/main.zip"
    function_name           = "generarToken"
    role                    = var.lambda_policy_arn
    handler                 = "main"
    runtime                 = "go1.x"
    vpc_config {
        subnet_ids          = [
            aws_subnet.private.id
        ]
        security_group_ids  = [
            aws_security_group.sg_global.id
        ]
    }
}

resource "aws_lambda_function" "validarToken" {
    filename                = "./lambda/main.zip"
    function_name           = "validarToken"
    role                    = var.lambda_policy_arn
    handler                 = "main"
    runtime                 = "go1.x"
    vpc_config {
        subnet_ids          = [
            aws_subnet.private.id
        ]
        security_group_ids  = [
            aws_security_group.sg_global.id
        ]
    }
}

resource "aws_lambda_function" "recomendacionesIniciales" {
    filename                = "./lambda/main.zip"
    function_name           = "recomendacionesIniciales"
    role                    = var.lambda_policy_arn
    handler                 = "main"
    runtime                 = "go1.x"
    vpc_config {
        subnet_ids          = [
            aws_subnet.private.id
        ]
        security_group_ids  = [
            aws_security_group.sg_global.id
        ]
    }
}

resource "aws_lambda_function" "obtenerHistorialFotos" {
    filename                = "./lambda/main.zip"
    function_name           = "obtenerHistorialFotos"
    role                    = var.lambda_policy_arn
    handler                 = "main"
    runtime                 = "go1.x"
    vpc_config {
        subnet_ids          = [
            aws_subnet.private.id
        ]
        security_group_ids  = [
            aws_security_group.sg_global.id
        ]
    }
}

resource "aws_lambda_function" "obtenerRecomendacionFotos" {
    filename                = "./lambda/main.zip"
    function_name           = "obtenerRecomendacionFotos"
    role                    = var.lambda_policy_arn
    handler                 = "main"
    runtime                 = "go1.x"
    vpc_config {
        subnet_ids          = [
            aws_subnet.private.id
        ]
        security_group_ids  = [
            aws_security_group.sg_global.id
        ]
    }
}

resource "aws_lambda_function" "obtenerPerfil" {
    filename                = "./lambda/main.zip"
    function_name           = "obtenerPerfil"
    role                    = var.lambda_policy_arn
    handler                 = "main"
    runtime                 = "go1.x"
    vpc_config {
        subnet_ids          = [
            aws_subnet.private.id
        ]
        security_group_ids  = [
            aws_security_group.sg_global.id
        ]
    }
}

resource "aws_lambda_function" "actualizarPerfil" {
    filename                = "./lambda/main.zip"
    function_name           = "actualizarPerfil"
    role                    = var.lambda_policy_arn
    handler                 = "main"
    runtime                 = "go1.x"
    vpc_config {
        subnet_ids          = [
            aws_subnet.private.id
        ]
        security_group_ids  = [
            aws_security_group.sg_global.id
        ]
    }
}