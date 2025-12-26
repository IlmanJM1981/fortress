#!/bin/bash
sudo ufw allow 5444/tcp
sudo sed -i "s/^Port 22/Port 5444/" /etc/ssh/sshd_config
sudo sed -i "s/^#Port 22/Port 5444/" /etc/ssh/sshd_config
if [ -d /etc/systemd/system/ssh.socket.d ]; then sudo systemctl stop ssh.socket && sudo systemctl disable ssh.socket; fi
sudo systemctl restart ssh && sudo ufw reload
echo "SHIELDS ACTIVE: PORT 5444"
