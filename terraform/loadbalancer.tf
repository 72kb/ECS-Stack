# Create Application Load Balancer
resource "aws_lb" "my_load_balancer" {
  name               = "${local.prefix}-my-load-balancer" # Replace with your desired load balancer name
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id] # Specify the subnet ID(s) where the load balancer should be placed

  security_groups = [aws_security_group.lb_security_group.id] # Specify the security group ID(s) for the load balancer

  tags = {
    Name = "${local.prefix}-my-load-balancer" # Replace with your desired load balancer name
  }
}

# Create Security Group for Load Balancer
resource "aws_security_group" "lb_security_group" {
  name        = "${local.prefix}-my-lb-security-group" # Replace with your desired security group name
  description = "Security group for load balancer"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with the allowed source IP addresses or range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Target Group for Load Balancer
resource "aws_lb_target_group" "my_target_group" {
  name        = "${local.prefix}-my-target-group" # Replace with your desired target group name
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = aws_vpc.my_vpc.id

  health_check {
    path = "/"
  }
}

# Create Listener for Load Balancer
resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_target_group.arn
  }
}

