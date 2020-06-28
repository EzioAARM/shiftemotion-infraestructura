#Tablas de dynamodb
resource "aws_dynamodb_table" "usuariosr1" {
    provider            = aws
    name                = "Usuarios"
    billing_mode        = "PAY_PER_REQUEST"
    hash_key            = "id"
    stream_enabled      = true
    stream_view_type    = "NEW_AND_OLD_IMAGES"

    attribute {
        name            = "id"
        type            = "N"
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
        type            = "N"
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