#Load Balancer
resource "aws_lb" "shiftEmotionSpotifyBlancer" {
    name                = "shiftEmotionSpotifyBlancer"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [
        aws_security_group.sg_global.id
    ]
    subnets             = [
        aws_subnet.public.*.id
    ]
}

resource "aws_ecr_repository" "shiftEmotion" {
    name                    = "shiftEmotionSpotify"
    image_tag_mutability    = "MUTABLE"
    image_scanning_configuration {
        scan_on_push        = false
    }
}

resource "aws_ecs_task_definition" "shiftEmotionSpotifyTask" {
    family                  = "shiftEmotionSpotifyTask"
    container_definitions   = <<TASK_DEFINITION
[
    {
        "cpu": 0.5,
        "memory": 128,
        "execution_role_arn": ${var.task_policy_arn}
        "image": ${aws_ecr_repository.shiftEmotion.repository_url},
        "portMappings": [
            {
                "containerHost": 80,
                "hostPort": 80
            }
        ]
    }
]
TASK_DEFINITION
}

resource "aws_ecs_cluster" "shiftEmotionSpotifyCluster" {
    name                    = "ShiftEmotionSpotifyCluster"
    capacity_providers      = "FARGATE"
}

resource "aws_ecs_service" "SpotifyIntegrationService" {
    name                    = "SpotifyIntegrationTask"
    cluster                 = aws_ecs_cluster.shiftEmotionSpotifyCluster.id
    task_definition         = aws_ecs_task_definition.shiftEmotionSpotifyTask.arn
    desired_count           = 2
    iam_role                = ""
}