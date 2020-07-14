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
        "environment": [
                {
                    "name": "AWS_ACCESS_KEY_ID",
                    "value": "${var.AWSaccessKey}"
                },
                {
                    "name": "AWS_SECRET_ACCESS_KEY",
                    "value": "${var.AWSsecretKey}"
                },
                {
                    "name": "S3_IMAGE_BUCKET",
                    "value": "${var.bucketImagenes}"
                },
                {
                    "name": "REGION",
                    "value": "us-west-2"
                }
            ],
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
    desired_count               = 1
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

resource "aws_cloudwatch_metric_alarm" "ShiftEmotionHighUsage" {
  alarm_name          = "ShiftEmotionHighUsage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  alarm_description = "This metric monitors ecs task cpu utilization"
  alarm_actions     = ["${aws_appautoscaling_policy.ecs_policy_scale_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ShiftEmotionLowUsage" {
  alarm_name          = "ShiftEmotionLowUsage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  alarm_description = "This metric monitors ecs task cpu utilization"
  alarm_actions     = ["${aws_appautoscaling_policy.ecs_policy_scale_down.arn}"]
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.shiftEmotionSpotifyCluster.name}/${aws_ecs_service.SpotifyAPI.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_scale_up" {
  name               = "ecs_policy_scale_up"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"
    step_adjustment {
        metric_interval_lower_bound = 0
        scaling_adjustment          = 2
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_scale_down" {
  name               = "ecs_policy_scale_down"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
        metric_interval_upper_bound = 0
        scaling_adjustment          = -1
    }
  }
}