#Tablas de dynamodb
resource "aws_dynamodb_table" "historialEscuchadas1" {
    provider            = aws
    name                = "HistorialEscuchadas"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "id"
    stream_enabled      = true
    stream_view_type    = "NEW_AND_OLD_IMAGES"

    attribute {
        name            = "id"
        type            = "N"
    }
}

resource "aws_dynamodb_table" "historialEscuchadas2" {
    provider            = aws.us-west-2
    name                = "HistorialEscuchadas"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "id"
    stream_enabled      = true
    stream_view_type    = "NEW_AND_OLD_IMAGES"

    attribute {
        name            = "id"
        type            = "N"
    }
}

resource "aws_dynamodb_global_table" "HistorialEscuchadas" {
    depends_on          = [
        aws_dynamodb_table.historialEscuchadas1,
        aws_dynamodb_table.historialEscuchadas2
    ]
    name                = "HistorialEscuchadas"
    replica {
        region_name          = "us-west-2"
    }

    replica {
        region_name          = "us-east-1"
    }
}

resource "aws_dynamodb_table" "historialFotosEmociones1" {
    provider            = aws
    name                = "HistorialFotosEmociones"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "id"
    stream_enabled      = true
    stream_view_type    = "NEW_AND_OLD_IMAGES"

    attribute {
        name            = "id"
        type            = "N"
    }
}

resource "aws_dynamodb_table" "historialFotosEmociones2" {
    provider            = aws.us-west-2
    name                = "HistorialFotosEmociones"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "id"
    stream_enabled      = true
    stream_view_type    = "NEW_AND_OLD_IMAGES"

    attribute {
        name            = "id"
        type            = "N"
    }
}

resource "aws_dynamodb_global_table" "HistorialFotosEmociones" {
    depends_on          = [
        aws_dynamodb_table.historialFotosEmociones1,
        aws_dynamodb_table.historialFotosEmociones2
    ]
    name                = "HistorialFotosEmociones"
    replica {
        region_name          = "us-west-2"
    }

    replica {
        region_name          = "us-east-1"
    }
}

resource "aws_dynamodb_table" "passwordsTokensr1" {
    provider            = aws
    name                = "PasswordsTokens"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "id"
    stream_enabled      = true
    stream_view_type    = "NEW_AND_OLD_IMAGES"

    attribute {
        name            = "id"
        type            = "S"
    }
}

resource "aws_dynamodb_table" "passwordsTokensr2" {
    provider            = aws.us-west-2
    name                = "PasswordsTokens"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "id"
    stream_enabled      = true
    stream_view_type    = "NEW_AND_OLD_IMAGES"

    attribute {
        name            = "id"
        type            = "S"
    }
}

resource "aws_dynamodb_global_table" "PasswordsTokens" {
    depends_on          = [
        aws_dynamodb_table.passwordsTokensr1,
        aws_dynamodb_table.passwordsTokensr2
    ]
    name                = "PasswordsTokens"
    replica {
        region_name          = "us-west-2"
    }

    replica {
        region_name          = "us-east-1"
    }
}

resource "aws_dynamodb_table" "recomendacionesr1" {
    provider            = aws
    name                = "Recomendaciones"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "id"
    stream_enabled      = true
    stream_view_type    = "NEW_AND_OLD_IMAGES"

    attribute {
        name            = "id"
        type            = "N"
    }
}

resource "aws_dynamodb_table" "recomendacionesr2" {
    provider            = aws.us-west-2
    name                = "Recomendaciones"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "id"
    stream_enabled      = true
    stream_view_type    = "NEW_AND_OLD_IMAGES"

    attribute {
        name            = "id"
        type            = "N"
    }
}

resource "aws_dynamodb_global_table" "Recomendaciones" {
    depends_on          = [
        aws_dynamodb_table.recomendacionesr1,
        aws_dynamodb_table.recomendacionesr2
    ]
    name                = "Recomendaciones"
    replica {
        region_name          = "us-west-2"
    }

    replica {
        region_name          = "us-east-1"
    }
}

resource "aws_dynamodb_table" "usuariosr1" {
    provider            = aws
    name                = "Usuarios"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "id"
    stream_enabled      = true
    stream_view_type    = "NEW_AND_OLD_IMAGES"

    attribute {
        name            = "id"
        type            = "S"
    }
}

resource "aws_dynamodb_table" "usuariosr2" {
    provider            = aws.us-west-2
    name                = "Usuarios"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "id"
    stream_enabled      = true
    stream_view_type    = "NEW_AND_OLD_IMAGES"

    attribute {
        name            = "id"
        type            = "S"
    }
}

resource "aws_dynamodb_global_table" "usuarios" {
    depends_on          = [
        aws_dynamodb_table.usuariosr1,
        aws_dynamodb_table.usuariosr2
    ]
    name                = "Usuarios"
    replica {
        region_name          = "us-west-2"
    }

    replica {
        region_name          = "us-east-1"
    }
}