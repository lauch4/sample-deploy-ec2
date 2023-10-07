# Definir el proveedor de AWS
provider "aws" {
  region = "us-east-1" # Cambia la región según tu preferencia
}

# Definir una clave SSH para acceder a la instancia EC2
resource "aws_key_pair" "my_keypair" {
  key_name   = "my-keypair"
  public_key = file("~/.ssh/id_rsa.pub") # Ruta a tu clave pública SSH
}

# Definir un grupo de seguridad para permitir el tráfico SSH, HTTP y Docker
resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow SSH, HTTP, and Docker traffic"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "ssh"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2376
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Definir una instancia EC2 con Ubuntu
resource "aws_instance" "web_server" {
  ami           = "ami-024e6efaf93d85776" # Imagen de Ubuntu Server 22.04 LTS
  instance_type = "t2.micro"              # Tipo de instancia gratuita
  
  key_name      = aws_key_pair.my_keypair.key_name
  security_groups = [aws_security_group.web.name]
  
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y

              # Copiar archivos del sitio web desde tu máquina local a la instancia
              sudo apt-get install -y rsync

              # Instalar Docker
              sudo apt-get install -y docker.io

              # Copiar docker-compose.yml desde tu máquina local a la instancia
              

              # Iniciar el contenedor Docker con docker-compose
              
              EOF
}

# Salida para obtener la dirección IP pública de la instancia EC2
output "public_ip" {
  value = aws_instance.web_server.public_ip
}
