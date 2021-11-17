resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = var.PUBLIC_KEY
}

