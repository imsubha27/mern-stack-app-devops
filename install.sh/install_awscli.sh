#AWS CLI installation script

#!/bin/bash
sudo apt install unzip -y
curl 'https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip' -o 'awscliv2.zip'
unzip awscliv2.zip
sudo ./aws/install