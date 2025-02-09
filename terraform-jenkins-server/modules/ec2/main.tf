#CREATE EC2 INSTANCE USING SECURITY GROUP
resource "aws_instance" "my-ec2" {
  ami           = var.ami   
  instance_type = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id = var.default_subnet_id
  key_name = var.key_name
  iam_instance_profile   = var.instance_profile_name

  root_block_device {
    volume_size = var.volume_size
  }
  
  tags = {
    Name = var.instance_name
  }
  
    # USING REMOTE-EXEC PROVISIONER TO INSTALL PACKAGES
  provisioner "remote-exec" {
    # ESTABLISHING SSH CONNECTION WITH EC2
    connection {
      type        = "ssh"
      private_key = file("./ec2-key.pem") #Terraform cannot SSH without key-pair
      user        = "ubuntu"
      host        = self.public_ip
    }

    inline = [

      # Install AWS CLI
      "sudo apt update -y",
      "sudo apt install -y curl unzip",
      "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
      "unzip awscliv2.zip",
      "sudo ./aws/install",


      # Install Docker
      "sudo apt update -y",
      "sudo apt install docker.io -y",
      "sudo usermod -aG docker jenkins",
      "sudo usermod -aG docker ubuntu",
      "sudo systemctl restart docker",
      "sudo chmod 777 /var/run/docker.sock",
      "docker --version",


      # Install SonarQube (as container)
      "docker run -d --name sonar -p 9000:9000 sonarqube:lts-community",


      # Install Trivy
      "sudo apt-get install wget apt-transport-https gnupg lsb-release -y",
      "wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -",
      "echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list",
      "sudo apt update",
      "sudo apt-get install trivy -y",


      #Install Terraform
      "wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg",
      "echo deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main | sudo tee /etc/apt/sources.list.d/hashicorp.list",
      "sudo apt update && sudo apt install terraform -y",
      "terraform --version",

 
      #Install kubectl
      "sudo curl -LO 'https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl'",
      "sudo chmod +x kubectl",
      "sudo mv kubectl /usr/local/bin/",
      "kubectl version --client",


      # Installing eksctl
      "sudo apt install -y curl tar",
      "curl --silent --location https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz | tar xz -C /tmp",
      "sudo mv /tmp/eksctl /usr/local/bin",
      "eksctl version",

      #Install helm
      "sudo snap install helm --classic",

      # Install Java
      "sudo apt update -y",
      "sudo apt install openjdk-17-jdk openjdk-17-jre -y",
      "java -version",

      # Install Jenkins
      "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
      "echo \"deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/\" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update -y",
      "sudo apt-get install -y jenkins",
      "sudo systemctl start jenkins",
      "sudo systemctl enable jenkins",

      # Get Jenkins initial login password
      "ip=$(curl -s ifconfig.me)",
      "pass=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)",

      # Output
      "echo 'Access Jenkins Server here --> http://'$ip':8080'",
      "echo 'Jenkins Initial Password: '$pass''",
      "echo 'Access SonarQube Server here --> http://'$ip':9000'",
      "echo 'SonarQube Username & Password: admin'",
    ]
  }
}  