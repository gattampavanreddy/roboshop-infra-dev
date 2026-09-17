resource "aws_instance" "mongodb" {
  ami           = local.ami_id
  instance_type = "t3.micro" 
  subnet_id     = local.database_subnet_id
  vpc_security_group_ids = [local.mongodb_sg_id]
  
  tags = merge(
    {
      Name = "${var.project}-${var.environment}-mongodb"
    },
    local.common_tags
  )
}

#whenever instance id changes, bootstarp code will be executed. 
#This is to ensure that if the instance is replaced, the bootstrap code will run again to set up the instance properly.

resource "terraform_data" "bootstrap" {
    triggers_replace = [
        aws_instance.mongodb.id
    ]

    connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.mongodb.private_ip
    }

    provisioner "file" {
        source = "bootstarp.sh" #local file path 
        destination = "/tmp/bootstarp.sh" #destination file path on the remote instance
    }
  
    provisioner "remote-exec" {
        inline = [
            "chmod +x /tmp/bootstarp.sh",
            "sudo sh /tmp/bootstarp.sh"
        ]
    }
}