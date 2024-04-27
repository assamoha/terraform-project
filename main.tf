
resource "aws_instance" "webserver" {
    ami = "ami-0a1179631ec8933d7"
    instance_type = "t2.micro"
    key_name = aws_key_pair.ec2_key.key_name
  
}

resource "null_resource" "n1" {
  connection {
    type  = "ssh"
    user = "ec2-user"
    private_key = file(local_file.ssh_key.filename)
    host = aws_instance.webserver.public_ip
  } 
  provisioner "local-exec" {
    command = "echo '${aws_instance.webserver.public_ip}' >> serverIp.log " 
  }
  provisioner "remote-exec" {
    inline = [
       "sudo useradd rayan",
       "mkdir Terraform",
       "touch serverIp.log",
       "echo '${aws_instance.webserver.public_ip}' >> serverIp.log" 
        
    ]
  
  }
  depends_on = [ aws_instance.webserver ]
}