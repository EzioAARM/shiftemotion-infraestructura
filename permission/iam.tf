#IAM Policy form lambda functions
data "aws_iam_policy_document" "lambda_policy_document" {
    statement {
        sid             = 1
        actions         = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "dynamodb:*",
            "s3:*Object",
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
        ]
        resources       = [
            "*"
        ]
    }
}

resource "aws_iam_policy" "lambda_policy" {
    name                = "shiftemotion_lambda_policy"
    description         = "Politica de ejecución y acceso a dynamodb de funciones lambda"
    policy              = data.aws_iam_policy_document.lambda_policy_document.json
}

resource "aws_iam_role" "lambda_role" {
    name                = "shiftemotion_lambda_role"
    assume_role_policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
    EOF
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attach" {
    role                = aws_iam_role.lambda_role.name
    policy_arn          = aws_iam_policy.lambda_policy.arn
}

output "lambda_policy_arn" {
    value = aws_iam_role.lambda_role.arn
}