
resource "aws_launch_template" "blue-launchtemplate" {
  name          = "blue-launchtemplate"
  image_id      = data.aws_ami.amazon_linux_2.image_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.mykeypair.key_name

  user_data = base64encode(templatefile("${path.module}/init-script.sh", {
    file_content = "version 1.4"
  }))

  network_interfaces {
    associate_public_ip_address = true # TODO Only for troubleshooting
    security_groups             = [module.web_server_public_sg.security_group_id]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "blue-autoscaling" {
  name                = "blue-autoscaling"
  vpc_zone_identifier = module.vpc_application.public_subnets
  launch_template {
    id      = aws_launch_template.blue-launchtemplate.id
    version = "$Latest"
  }
  min_size                  = var.blue_instance_count
  max_size                  = var.blue_instance_count
  force_delete              = true
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.blue.arn]
}

resource "aws_lb_target_group" "blue" {
  name     = "blue-tg-${random_pet.app.id}-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc_application.vpc_id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}
