resource "aws_launch_configuration" "yacob_launch_configuration_2" {
  name                        = "as_conf_tf_yacob_2"
  image_id                    = var.app_ami_id
  instance_type               = "t2.micro"
  security_groups             = ["sg-0ceeacc84f2620105"]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy     = true

  }
}

resource "aws_autoscaling_group" "yacob_tf_asg" {
  name                 = "yacob_tf_asg2"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_configuration = aws_launch_configuration.yacob_launch_configuration_2.name
  vpc_zone_identifier  = ["subnet-08283d6ac22034598"]
  health_check_grace_period = 100
  health_check_type    = "EC2"
  force_delete         = true  
      timeouts {
    delete = "15m"
  }
    tag {
    key                 = "Name"
    value               = "yacob_tf_asg"
    propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "auto_scale_up_yacob" {
    name                   = "yacob_autoscale_up"
    autoscaling_group_name = aws_autoscaling_group.yacob_tf_asg.name
    adjustment_type        = "ChangeInCapacity"
    scaling_adjustment     = 1
    cooldown               = 60
    policy_type            = "SimpleScaling" 
}

# define cloudwatch monitoring
resource "aws_cloudwatch_metric_alarm" "yacob_custom_cpu_alarm_scaleup" {
    alarm_name            = "yacob_custom_cpu_alarm_scaleup"
    alarm_description     = "sets alarm once CPU usage increases"
    comparison_operator   = "GreaterThanOrEqualToThreshold"
    evaluation_periods    = 2
    metric_name           = "CPUUtilization"
    namespace             = "AWS/EC2"
    period                = 120
    statistic             = "Average"
    threshold             = 25

    dimensions = {
        AutoScalingGroupName: aws_autoscaling_group.yacob_tf_asg.name
    }
    actions_enabled = true
    alarm_actions   = [aws_autoscaling_policy.auto_scale_up_yacob.arn]
}

# auto descaling policy
resource "aws_autoscaling_policy" "auto_descale_yacob" {
    name                   = "yacob_descale_auto"
    autoscaling_group_name = aws_autoscaling_group.yacob_tf_asg.name
    adjustment_type        = "ChangeInCapacity"
    scaling_adjustment     = -1
    cooldown               = 60
    policy_type            = "SimpleScaling" 
}

# descaling cloudwatch
resource "aws_cloudwatch_metric_alarm" "yacob_custom_cpu_alarm_descale" {
    alarm_name            = "yacob_custom_cpu_alarm_descale"
    alarm_description     = "sets alarm once CPU usage decreases"
    comparison_operator   = "LessThanOrEqualToThreshold"
    evaluation_periods    = 2
    metric_name           = "CPUUtilization"
    namespace             = "AWS/EC2"
    period                = 120
    statistic             = "Average"
    threshold             = 10

    dimensions = {
        "AutoScalingGroupName": aws_autoscaling_group.yacob_tf_asg.name
    }
    actions_enabled = true
    alarm_actions   = [aws_autoscaling_policy.auto_descale_yacob.arn]
}

# alb

resource "aws_alb" "yacob_load_balancer" {
    name            = "yacob-load-balancer"
    security_groups = ["sg-0ceeacc84f2620105"]
    # subnets         = [aws_subnet.eng103_yacob_tf_vpc_publicSN.id, aws_subnet.eng103_yacob_tf_vpc_publicSN2.id, aws_subnet.eng103_yacob_tf_vpc_publicSN3]
    subnets         = ["subnet-08283d6ac22034598", "subnet-070720afbdfd15d3c", "subnet-01b6cabec06c13fc6"]
    tags = {
        Name = "yacob_load_balancer"
    }
}

resource "aws_lb_target_group" "target_group" {
  name     = "yacob-tg"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = "vpc-0bbb458209ab89fbc"
}

resource "aws_alb_listener" "listener" {
    load_balancer_arn = aws_alb.yacob_load_balancer.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.target_group.arn
      
    }
}

resource "aws_autoscaling_attachment" "as_attachment" {
    autoscaling_group_name = aws_autoscaling_group.yacob_tf_asg.id
    lb_target_group_arn   = aws_lb_target_group.target_group.arn
}