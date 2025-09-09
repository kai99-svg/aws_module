########################################
# LOAD BALANCER
########################################

resource "aws_lb" "lb" {
  name               = "web"
  load_balancer_type = "application"
  subnets            = [aws_subnet.my_subnet.id, aws_subnet.dev_subnet.id]
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "instances" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.first_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "instances1" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.instance1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instances2" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.instance2.id
  port             = 80
}

resource "aws_lb_listener_rule" "instances" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instances.arn
  }
}