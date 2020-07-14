# ARN de Roles
output "LambdaBuildIAMRole_arn" {
    value = aws_iam_role.LambdaBuildIAMRole.arn
}

output "LambdaPipelineIAMRole_arn" {
    value = aws_iam_role.LambdaPipelineIAMRole.arn
}

output "LambdaDeployIAMRole_arn" {
    value = aws_iam_role.LambdaDeployIAMRole.arn
}

output "ECRDockerBuildIAMRole_arn" {
    value = aws_iam_role.ECRDockerBuildIAMRole.arn
}

output "ECRPipelineIAMRole_arn" {
    value = aws_iam_role.ECRPipelineIAMRole.arn
}

output "ECRDeployIAMRole_arn" {
    value = aws_iam_role.ECRDeployIAMRole.arn
}

output "S3PipelineRole_arn" {
    value = aws_iam_role.S3PipelineRole.arn
}

output "S3DeployRole_arn" {
    value = aws_iam_role.S3DeployRole.arn
}

output "WebAppBuildIAMRole_arn" {
    value = aws_iam_role.WebAppBuildIAMRole.arn
}

output "WebAppPipelineIAMRole_arn" {
    value = aws_iam_role.WebAppPipelineIAMRole.arn
}

output "WebAppDeployIAMRole_arn" {
    value = aws_iam_role.WebAppDeployIAMRole.arn
}

output "shiftEmotionTaskRole_arn" {
    value = aws_iam_role.shiftEmotionTaskRole.arn
}

# Id de Roles
output "LambdaBuildIAMRole_id" {
    value = aws_iam_role.LambdaBuildIAMRole.id
}

output "LambdaPipelineIAMRole_id" {
    value = aws_iam_role.LambdaPipelineIAMRole.id
}

output "LambdaDeployIAMRole_id" {
    value = aws_iam_role.LambdaDeployIAMRole.id
}

output "ECRDockerBuildIAMRole_id" {
    value = aws_iam_role.ECRDockerBuildIAMRole.id
}

output "ECRPipelineIAMRole_id" {
    value = aws_iam_role.ECRPipelineIAMRole.id
}

output "ECRDeployIAMRole_id" {
    value = aws_iam_role.ECRDeployIAMRole.id
}

output "S3PipelineRole_id" {
    value = aws_iam_role.S3PipelineRole.id
}

output "S3DeployRole_id" {
    value = aws_iam_role.S3DeployRole.id
}

output "WebAppBuildIAMRole_id" {
    value = aws_iam_role.WebAppBuildIAMRole.id
}

output "WebAppPipelineIAMRole_id" {
    value = aws_iam_role.WebAppPipelineIAMRole.id
}

output "WebAppDeployIAMRole_id" {
    value = aws_iam_role.WebAppDeployIAMRole.id
}

output "shiftEmotionTaskRole_id" {
    value = aws_iam_role.shiftEmotionTaskRole.id
}