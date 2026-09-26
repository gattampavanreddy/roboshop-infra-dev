resource "aws_instance" "catalofue" {
  ami           = local.ami_id
  instance_type = "t3.micro" 
  subnet_id     = local.private_subnet_ids
  vpc_security_group_ids = [local.catalogue_sg_id]
  
  tags = merge(
    {
      Name = "${var.project}-${var.environment}-catalogue"
    },
    local.common_tags
  )
}


resource "terraform_data" "catalogue" {
    triggers_replace = [
        aws_instance.catalogue.id
    ]

    connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.catalogue.private_ip
    }

    provisioner "file" {
        source = "bootstarp.sh" #local file path 
        destination = "/tmp/bootstarp.sh" #destination file path on the remote instance
    }
  
    provisioner "remote-exec" { 
        inline = [
            "chmod +x /tmp/bootstarp.sh",
            "sudo sh /tmp/bootstarp.sh catalogue ${var.environment}"
        ]
    }
}



