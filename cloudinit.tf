data "template_file" "init-script" {
  template = file("scripts/init.cfg")
  vars = {
    region = var.AWS_REGION
  }
}

data "template_cloudinit_config" "cloudinit-app-instance" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init-script.rendered
  }
  # TODO Remove
  part {
    content_type = "text/x-shellscript"
    content      = "#!/bin/bash\necho hello"
  }
}

