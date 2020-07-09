#Load Balancer y Target group
resource "aws_lb_target_group" "shiftEmotionSpotifyTarget" {
    name                = "shiftEmotionSpotifyTarget"
    port                = 80
    protocol            = "HTTP"
    target_type         = "ip"
    vpc_id              = aws_vpc.ShiftEmotionVPC.id

    depends_on          = [
                            aws_lb.shiftEmotionSpotifyBlancer
                        ]
}

resource "aws_lb" "shiftEmotionSpotifyBlancer" {
    name                = "shiftEmotionSpotifyBlancer"
    internal            = false
    load_balancer_type  = "application"
    security_groups     = [
        aws_security_group.sg_global.id
    ]
    subnets             = [
        aws_subnet.public.id,
        aws_subnet.public2.id
    ]
}

resource "aws_lb_listener" "shiftEmotionSpotifyBalancerListener" {
    load_balancer_arn   = aws_lb.shiftEmotionSpotifyBlancer.arn
    port                = 80
    protocol            = "HTTP"
    default_action {
        type            = "forward"
        target_group_arn= aws_lb_target_group.shiftEmotionSpotifyTarget.arn
    }
}

resource "aws_ecr_repository" "shiftEmotion" {
    name                    = "shiftemotionspotify"
    image_tag_mutability    = "MUTABLE"
    image_scanning_configuration {
        scan_on_push        = false
    }
}

resource "aws_iam_role" "shiftEmotionTaskRole" {
    name                    = "shiftEmotionTaskRole"
    assume_role_policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
    EOF
}

resource "aws_iam_role_policy" "shiftEmotionTaskPolicy" {
    name                    = "shiftEmotionTaskPolicy"
    role                    = aws_iam_role.shiftEmotionTaskRole.id
    policy                  = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
    EOF
}

resource "aws_ecs_task_definition" "shiftEmotionSpotifyTask" {
    family                      = "shiftEmotionSpotifyTask"
    cpu                         = "256"
    memory                      = "512"
    network_mode                = "awsvpc"
    task_role_arn               = aws_iam_role.shiftEmotionTaskRole.arn
    execution_role_arn          = aws_iam_role.shiftEmotionTaskRole.arn
    requires_compatibilities    = [
        "FARGATE"
    ]
    container_definitions       = <<TASK_DEFINITION
[
    {
        "name": "ShiftEmotionSpotifyIntegration",
        "essential": true,
        "cpu": 128,
        "memory": 256,
        "memoryReservation": 128,
        "execution_role_arn": "${aws_iam_role.shiftEmotionTaskRole.arn}",
        "image": "${aws_ecr_repository.shiftEmotion.repository_url}:latest",
        "portMappings": [
            {
                "containerPort": 3000,
                "hostPort": 3000,
                "protocol": "tcp"
            }
        ]
    }
]
TASK_DEFINITION
}

resource "aws_ecs_cluster" "shiftEmotionSpotifyCluster" {
    name                        = "ShiftEmotionSpotifyCluster"
    capacity_providers          = [
        "FARGATE"
    ]
}

resource "aws_ecs_service" "SpotifyAPI" {
    name                        = "SpotifyAPI"
    cluster                     = aws_ecs_cluster.shiftEmotionSpotifyCluster.id
    task_definition             = aws_ecs_task_definition.shiftEmotionSpotifyTask.arn
    launch_type                 = "FARGATE"
    desired_count               = 2
    load_balancer {
        target_group_arn        = aws_lb_target_group.shiftEmotionSpotifyTarget.arn
        container_name          = "ShiftEmotionSpotifyIntegration"
        container_port          = 3000
    }
    network_configuration {
        subnets                 = [
            aws_subnet.public.id,
            aws_subnet.public2.id
        ]
        security_groups         = [
            aws_security_group.sg_global.id
        ]
        assign_public_ip        = true
    }
}