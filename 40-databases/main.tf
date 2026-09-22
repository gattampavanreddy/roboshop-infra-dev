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
            "sudo sh /tmp/bootstarp.sh mongodb ${var.environment}"
        ]
    }
}



#=========================================================

resource "aws_instance" "redis" {
  ami           = local.ami_id
  instance_type = "t3.micro" 
  subnet_id     = local.database_subnet_id
  vpc_security_group_ids = [local.redis_sg_id]
  
  tags = merge(
    {
      Name = "${var.project}-${var.environment}-redis"
    },
    local.common_tags
  )
}

#whenever instance id changes, bootstarp code will be executed. 
#This is to ensure that if the instance is replaced, the bootstrap code will run again to set up the instance properly.

resource "terraform_data" "bootstrap_redis" {
    triggers_replace = [
        aws_instance.redis.id
    ]

    connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.redis.private_ip
    }

    provisioner "file" {
        source = "bootstarp.sh" #local file path 
        destination = "/tmp/bootstarp.sh" #destination file path on the remote instance
    }
  
    provisioner "remote-exec" { 
        inline = [
            "chmod +x /tmp/bootstarp.sh",
            "sudo sh /tmp/bootstarp.sh redis ${var.environment}"
        ]
    }
}

#=========================================================

resource "aws_instance" "mysql" {
  ami           = local.ami_id
  instance_type = "t3.micro" 
  subnet_id     = local.database_subnet_id
  vpc_security_group_ids = [local.mysql_sg_id]
  iam_instance_profile = aws_iam_instance_profile.mysql.name
  
  tags = merge(
    {
      Name = "${var.project}-${var.environment}-mysql"
    },
    local.common_tags
  )
}

resource "terraform_data" "mysql" {
    triggers_replace = [
        aws_instance.mysql.id
    ]

    connection {
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
    host = aws_instance.mysql.private_ip
    }

    provisioner "file" {
        source = "bootstarp.sh" #local file path 
        destination = "/tmp/bootstarp.sh" #destination file path on the remote instance
    }
  
    provisioner "remote-exec" { 
        inline = [
            "chmod +x /tmp/bootstarp.sh",
            "sudo sh /tmp/bootstarp.sh mysql"
        ]
    }
}