provider "aws" {
  region = "us-east-1"  # Cambia la región según tu preferencia
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-06db4d78cb1d3bbf9"  # ID de la AMI que deseas usar debian12
  instance_type = "t2.micro"               # Tipo de instancia
  key_name      = "nombre_de_tu_clave"     # Nombre de la clave SSH existente en AWS

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install wget unzip -y
              sudo apt-get install docker.io -y
              sudo apt-get install git -y
              sudo groupadd docker
              sudo usermod -aG docker admin
              sudo newgrp docker
              sudo mkdir sitio
              cd /sitio/
              sudo git clone https://github.com/lauch4/lautaro-landing.git
              sudo docker run -d --name apache-lautaro -p 80:80 -v /sitio/lautaro-landing/codigo:/usr/local/apache2/htdocs/ httpd:2.4
              EOF
}

# Puedes agregar recursos adicionales aquí, como un grupo de seguridad, clave SSH, etc.
