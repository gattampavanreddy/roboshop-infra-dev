variable "project" {
    default = "roboshop"
}

variable "environment" {
    default = "dev"
}

variable "sg_names" {
    type = list(string)
    default = [
        # Database
        "mongodb","redis","mysql","rabbitmq",
        #Backend
        "catalogue","user","cart","shipping","payment",
        #Backend ALB
        "backend_alb",
        #Frontend
        "frontend",
        #Frontend ALB
        "frontend_alb",
        #Bastion/jump host
        "bastion"
    ]
}
