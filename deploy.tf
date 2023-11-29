terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws",
        version = "~> 5.0"
    }    
  }
}

provider "aws" {
    region = "eu-north-1"

}
//Create keypair for my instance
# resource "tls_private_key" "testkey" {
#     algorithm = "RSA"
#     rsa_bits = "4096"
# }
resource "aws_key_pair" "sam_key_key_pair" {
    key_name = "sam_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+e6bUk2pDm16DzeNLdJEWAGYcKl+4PxqReC3a28IhEmBr/wdPLuSD0LgLR0fh1R/cfLcsMwaJFEVWNdyp9KTbei0gd9dWU/gqEecax+3X1n9gbeY5x4TjYqrV/dVldsNhFKkAwNbcerSAS7MCtnCg57o2QgQqblyH39vIDPVAGPeNIGuRUk+kAdd1tz2MJVGx2u53v8piZMPJuQTe9M4NcGPbaS++HG4YUPIRzzwT8UHfjjjCHOavHy3ukG4hiiNRmzLTwg3KLP6W/cwG+ATOCT63JiA/JJwkb+ow4JACp1HyseF5sMG3G7lpSvjRKr/fsg2jVZpKiikT4E2B2Y15N4sQpQc8+jNFjOq8F1iMIXb2oH3Lx70aO8xFfyeOQsx3YkC2T1pBLmJyTdGl/3leW3hVttS4yMk1PRPwIgzcq7ABWWLBPdWgR71ewVIYlOycta5KOIKveYLMftY63P5JhJas5s7Dhm1rHK5Gfis1fLkYuIC7uo0JQxtWORK4WvM= sam@voltron"
}

//save the private key
# resource "local_file" "storing_test_pem"{
#     content = tls_private_key.testkey.private_key_pem
#     filename = aws_key_pair.testkey_key_pair.key_name
# }
//security group
resource "aws_security_group" "Create_test2_sg" {
    name = "create_test2_sg"
    description = "This allows access to the instances"
    vpc_id = "vpc-0154e272942664be2"

    ingress {
        description = "Allow SSH access"
        protocol = "TCP"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow HTTP access"
        protocol = "TCP"
        from_port = 80
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        description = "outbound traffic for demo instance"
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "security group for demo instance"
    }
}
//create an instance 
resource "aws_instance" "demo_instance" {
    ami = "ami-0989fb15ce71ba39e"
    instance_type = "t3.micro"
    subnet_id = "subnet-054aed4057bcd3739"
    count = 1
    key_name = aws_key_pair.sam_key_key_pair.key_name
    vpc_security_group_ids = [aws_security_group.Create_test2_sg.id]
    associate_public_ip_address = true
    user_data = file("/home/sam/Documents/practicum/designo-website/ass.sh")
    tags = {
        Name = "demo_instance"
    }

    connection {
        host = self.public_ip
        type = "ssh"
        user = "ubuntu"
        private_key = "${file("sam_key")}"

    }

    provisioner "remote-exec" {
        script = "/home/sam/Documents/practicum/designo-website/ass.sh"
        when = create
    }
}
