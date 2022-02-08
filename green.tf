# Green YAML contains ALL resources REPLACED by Terraform as you dynamically orchestrate your infra and application deployments
# resource "aws_instance" "green" {
#   count = var.enable_green_env ? var.green_instance_count : 0

#   ami                    = data.aws_ami.amazon_linux_2.id
#   instance_type          = var.instance_type
#   # Smear instance across subnets 
#   # subnet_id              = module.vpc_application.public_subnets[count.index % length(module.vpc_application.public_subnets)]
#   vpc_security_group_ids = [module.web_server_public_sg.security_group_id]
#   user_data = templatefile("${path.module}/init-script.sh", {
#     file_content = "version 1.3 - #${count.index}"
#   })
# }

# TODO rename example > green
resource "aws_launch_template" "example-launchtemplate" {
  name          = "example-launchtemplate"
  image_id      = data.aws_ami.amazon_linux_2.image_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.mykeypair.key_name

  user_data = base64encode(templatefile("${path.module}/init-script.sh", {
    file_content = "version 1.3"
  }))

  network_interfaces {
    associate_public_ip_address = true # TODO Only for troubleshooting
    security_groups             = [module.web_server_public_sg.security_group_id]
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example-autoscaling" {
  name                = "example-autoscaling"
  vpc_zone_identifier = module.vpc_application.public_subnets
  launch_template {
    id      = aws_launch_template.example-launchtemplate.id
    version = "$Latest"
  }
  min_size                  = var.green_instance_count
  max_size                  = var.green_instance_count
  force_delete              = true
  health_check_type         = "EC2"
  health_check_grace_period = 300
  target_group_arns         = [aws_lb_target_group.green.arn]
}

resource "aws_lb_target_group" "green" {
  name     = "green-tg-${random_pet.app.id}-lb"
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

# resource "aws_lb_target_group_attachment" "green" {
#   # count            = length(aws_instance.green)

#   target_group_arn = aws_lb_target_group.green.arn
#   # How to attach to ASG?? ASG > TG
#   # target_id        = aws_instance.green[count.index].id
#   port             = 80
# }
