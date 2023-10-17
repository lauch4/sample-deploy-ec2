module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type          = "t2.micro"
  ami                    = "ami-06db4d78cb1d3bbf9"
  key_name               = "web-victus"
  monitoring             = true
  vpc_security_group_ids = ["sg-0090e4169f256dc56"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}