provider "aws"{
    region = "${var.AWS_REGION}"
}

resource "aws_instance" "ApacheInstance" {
    ami = "ami-0eea504f45ef7a8f7"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.private_subnet.id
    security_groups = [aws_security_group.EC2SG.id]
    associate_public_ip_address = false
    key_name = "ubuntuOhio"
    user_data = <<-EOF
      #!/bin/bash
      echo "*** Installing apache2"
      sudo apt update -y
      sudo apt install apache2 -y
      echo "*** Completed Installing apache2"
    EOF
    tags = {
        Name = "ApacheInstance"
    }
}

resource "aws_lb_target_group" "my-target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "my-test-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      =  aws_vpc.main_vpc_terraform.id
}

resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment1" {
  target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
  target_id        = aws_instance.ApacheInstance.id
  port             = 80
}


resource "aws_lb" "my-aws-alb" {
  name     = "my-test-alb"
  internal = false

  security_groups = [
    "${aws_security_group.LoadBalancerSG.id}",
  ]

  subnets = [
      aws_subnet.loadbalancer_subnet_2b.id,
      aws_subnet.loadbalancer_subnet_2c.id
  ]

  tags = {
    Name = "my-test-alb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

resource "aws_lb_listener" "my-test-alb-listner" {
  load_balancer_arn = "${aws_lb.my-aws-alb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
  }
}
