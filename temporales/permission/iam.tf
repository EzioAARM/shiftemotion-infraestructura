#IAM Policy for task definition
data "aws_iam_policy_document" "task_definition_policy_document" {
    statement {
        sid             = 1
        actions         = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        resources       = [
            "*"
        ]
    }
}

resource "aws_iam_policy" "task_definition_policy" {
    name                = "task_definition_policy"
    description         = "Politica para la task definition de ECS"
    policy              = data.aws_iam_policy_document.task_definition_policy_document.json
}

resource "aws_iam_role" "shiftemotion_task_execution_role" {
    name                = "shiftemotion_task_execution_role"
    assume_role_policy  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ecs.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
    EOF
}

resource "aws_iam_role_policy_attachment" "task_definition_role_policy_attach" {
    role                = aws_iam_role.shiftemotion_task_execution_role.name
    policy_arn          = aws_iam_policy.task_definition_policy.arn
}

output "task_definition_role_arn" {
    value = aws_iam_role.shiftemotion_task_execution_role.arn
}