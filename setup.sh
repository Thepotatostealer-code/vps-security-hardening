#!/bin/bash
USER=$(whoami)

echo "Entering setup script..."
read -p "Enter New SSH Port: " SSH_NEW_PORT

read -p "Enter SSH Fail Attempts: " SSH_FAIL_ATTEMPTS

read -p "Enter SSH Ban Time (in seconds): " SSH_BAN_TIME

read -p "Do you want to change the password for the current user? (yes/no): " Changepassword
if [[ "$Changepassword" == "yes" ]]; then
    read -p "Enter new password: " NEW_PASSWORD
    echo "Changing password for user $USER..."
    echo "$USER:$NEW_PASSWORD" | sudo chpasswd
    if [ $? -eq 0 ]; then
        echo "Password changed successfully for user $USER."
    else
        echo "Failed to change password for user $USER." 
    fi   
else
    echo "Password change skipped."
fi

echo "Testing SSH Port: $SSH_NEW_PORT, Fail Attempts: $SSH_FAIL_ATTEMPTS, Ban Time: $SSH_BAN_TIME, Change Password: $Changepassword"

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y  
echo "Installing Fail2Ban..."
sudo apt install fail2ban -y
echo "Configuring Fail2Ban..."
sudo bash -c "cat > /etc/fail2ban/jail.local <<EOL
[sshd]
enabled = true
port = $SSH_NEW_PORT
logpath = %(sshd_log)s
backend = %(sshd_backend)s
maxretry = $SSH_FAIL_ATTEMPTS
bantime  = $SSH_BAN_TIME
EOL"
echo "Restarting Fail2Ban service..."
sudo systemctl restart fail2ban
echo "Checking Fail2Ban status..."
fail2ban-client --test
if [ $? -eq 0 ]; then
    echo "Fail2Ban is configured correctly."
else
    echo "There was an issue with the Fail2Ban configuration."
fi
echo "Changing SSH port to $SSH_NEW_PORT..."
sudo sed -i "s/#Port 22/Port $SSH_NEW_PORT/" /etc/ssh/sshd_config

sudo mkdir -p /etc/systemd/system/ssh.socket.d/

sudo tee /etc/systemd/system/ssh.socket.d/override.conf > /dev/null <<EOF
[Socket]
ListenStream=
ListenStream=0.0.0.0:$SSH_NEW_PORT
ListenStream=[::]:$SSH_NEW_PORT
BindIPv6Only=ipv6-only
Accept=no
FreeBind=yes
EOF
echo "Setting up firewall rules..."
sudo ufw allow $SSH_NEW_PORT/tcp
yes | sudo ufw enable
echo "Restarting SSH service..."
sudo systemctl restart ssh
sudo systemctl restart ssh.socket
systemctl daemon-reload
echo ""
echo "=============================="
echo "Security Hardening Report"
echo "=============================="
echo "SSH Port: $SSH_NEW_PORT"
echo "Fail2ban Max Attempts: $SSH_FAIL_ATTEMPTS"
echo "Fail2ban Ban Time: $SSH_BAN_TIME seconds"
echo "SSH Service: $(systemctl is-active ssh)"
echo "Fail2ban Service: $(systemctl is-active fail2ban)"
echo "UFW Status: $(sudo ufw status | head -1)"
echo "=============================="
