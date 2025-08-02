resource "aws_security_group" "bastion-host-sg" {
  name        = "d-bastion-host-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "d-bastion-host-sg"
  }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
}
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
}
}
resource "aws_security_group" "alb-sg" {
    name        = "d-alb-sg"
    description = "Security group for ALB"
    vpc_id      = var.vpc_id
    tags = {
        "Name" = "d-alb-sg"
    }
        ingress {
            from_port   = 80
            to_port     = 80
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
}
        ingress {
            from_port   = 443
            to_port     = 443
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
}
        egress {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }
}
resource "aws_security_group" "private-sg" {
  name        = "private-sg"
  description = "Security group for ansible"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "private-sg"
  }
    ingress {
        from_port   = 22
        to_port     = 22
        description = "Allow SSH access from bastion host"
        protocol    = "tcp"
        security_groups = [aws_security_group.bastion-host-sg.id]
}
    ingress {
        from_port   = 3000
        to_port     = 3000
        description = "Open port for Grafana"
        protocol    = "tcp"
        security_groups = [aws_security_group.alb-sg.id]
    }
    ingress {
        from_port   = 9090
        to_port     = 9090
        description = "Open port for Prometheus"
        protocol    = "tcp"
        security_groups = [aws_security_group.alb-sg.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_security_group" "ecs-cluster-sg" {
  name        = "ecs-cluster-sg"
  description = "Security group for ECS cluster"
  vpc_id      = var.vpc_id
  tags = {
    "Name" = "ecs-cluster-sg"
  }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.alb-sg.id]
        description = "Allow HTTPS traffic from ALB"
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}