#!/bin/bash
sudo ufw allow 22/tcp
sudo sed -i "s/^Port 5444/Port 22/" /etc/ssh/sshd_config
sudo systemctl restart ssh && sudo ufw reload
echo "SHIELDS DOWN: PORT 22"
