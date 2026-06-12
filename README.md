# VPS Security Hardening Script

Automated security hardening for VPS/Linux servers. Configures SSH hardening, Fail2ban brute-force protection, and UFW firewall in one command.

---

## 🎯 What It Does

This script automates critical security configurations to protect your VPS from unauthorized access and brute-force attacks:

- **SSH Hardening** - Changes SSH port, configures secure settings
- **Fail2ban Setup** - Blocks IPs after failed login attempts
- **UFW Firewall** - Configures firewall rules for network security
- **Password Management** - Optional password change for current user
- **Configuration Validation** - Verifies all settings before applying
- **Error Handling** - Gracefully handles errors and provides feedback

---

## 🚀 Quick Start

### Prerequisites
- VPS/Linux server (Ubuntu/Debian)
- Root or sudo access
- SSH access to the server

### Installation & Execution

**Step 1: Download the script**
```bash
wget https://raw.githubusercontent.com/Thepotatostealer-code/vps-security-hardening/main/setup.sh
```

Or clone the repository:
```bash
git clone https://github.com/Thepotatostealer-code/vps-security-hardening.git
cd vps-security-hardening
```

**Step 2: Make the script executable**
```bash
chmod +x setup.sh
```

**Step 3: Run the script**
```bash
sudo ./setup.sh
```

**Step 4: Follow the prompts**
```
Entering setup script...
Enter New SSH Port: 41200
Enter SSH Fail Attempts: 5
Enter SSH Ban Time (in seconds): 3600
Do you want to change the password for the current user? (yes/no): yes
Enter new password: ••••••••
```

**Step 5: Done!**
```
SSH port changed to 41200, Firewall setup and Fail2Ban configured successfully.
```

---

## 📋 Configuration Options

When you run the script, you'll be prompted for:

| Option | Description | Example |
|--------|-------------|---------|
| **SSH Port** | New SSH port (1-65535) | 41200 |
| **Fail Attempts** | Max failed attempts before ban | 5 |
| **Ban Time** | How long to ban (seconds) | 3600 (1 hour) |
| **Password Change** | Change current user password | yes/no |

### Recommended Settings

```
SSH Port: 41200 (avoid common ports like 22, 2222)
Fail Attempts: 5 (ban after 5 failed attempts)
Ban Time: 3600 (ban for 1 hour)
Password Change: yes (use strong password)
```

---

## 🔒 Security Features

### SSH Hardening
- Changes SSH port from default 22
- Configures systemd socket for custom port
- Validates SSH configuration before applying
- Supports both IPv4 and IPv6

### Fail2ban Protection
- Monitors failed SSH login attempts
- Automatically bans IPs after X failed attempts
- Configurable ban duration
- Real-time protection against brute-force attacks

### UFW Firewall
- Enables UFW firewall
- Opens SSH port (22 and custom port)
- Blocks all other incoming traffic by default
- Provides network-level protection

### Validation & Error Handling
- Tests SSH configuration before restarting
- Validates Fail2ban setup
- Provides clear error messages
- Continues safely on errors

---

## 📊 What Gets Configured

### SSH Configuration (`/etc/ssh/sshd_config`)
```
Port 41200
```

### Fail2ban Configuration (`/etc/fail2ban/jail.local`)
```
[sshd]
enabled = true
port = 41200
logpath = %(sshd_log)s
backend = %(sshd_backend)s
maxretry = 5
bantime = 3600
```

### Firewall Rules (UFW)
```
Allow: Port 22/tcp (SSH)
Allow: Port 41200/tcp (Custom SSH)
Deny: All other incoming traffic
```

---

## 🔄 How It Works

1. **Gather Configuration** - Prompts user for SSH port, fail attempts, ban time
2. **Update System** - Updates package lists and upgrades packages
3. **Install Fail2ban** - Installs Fail2ban service
4. **Configure Fail2ban** - Creates jail.local with user settings
5. **Change SSH Port** - Updates sshd_config with new port
6. **Configure Firewall** - Sets up UFW rules and enables firewall
7. **Restart Services** - Restarts SSH and Fail2ban services
8. **Validate** - Tests Fail2ban configuration
9. **Report** - Shows final status and settings

---

## ⚠️ Important Notes

### Before Running

- **Backup Your Config** - Script creates backups automatically
- **Test Connection** - Keep current SSH session open to test
- **Know Your Port** - Remember the new SSH port you set
- **Strong Password** - Use a strong password if changing it

### After Running

- **Update SSH Connection** - Connect to new SSH port
  ```bash
  ssh -p 41200 user@your-vps-ip
  ```

- **Monitor Fail2ban** - Check ban status
  ```bash
  sudo fail2ban-client status sshd
  ```

- **Check Firewall** - Verify UFW rules
  ```bash
  sudo ufw status
  ```

### Troubleshooting

**Can't connect after running script?**
- Check SSH port is correct: `sudo ufw status`
- Verify SSH service is running: `sudo systemctl status ssh`
- Check Fail2ban isn't blocking you: `sudo fail2ban-client status sshd`

**Fail2ban not working?**
- Test config: `sudo fail2ban-client --test`
- Check status: `sudo fail2ban-client status sshd`
- View logs: `sudo tail -f /var/log/fail2ban.log`

**Firewall blocking connections?**
- List rules: `sudo ufw status numbered`
- Allow port: `sudo ufw allow 41200/tcp`
- Reload: `sudo ufw reload`

---

## 📝 Script Features

### User Input Validation
- Prompts for all required settings
- Displays configuration before applying
- Allows user confirmation

### Error Handling
- Checks if commands succeed
- Provides clear error messages
- Continues safely on non-critical errors

### Service Management
- Installs required packages
- Manages systemd services
- Validates all configurations

### Logging & Feedback
- Shows progress with clear messages
- Reports success/failure for each step
- Displays final status summary

---

## 🛠️ System Requirements

| Requirement | Minimum |
|-------------|---------|
| OS | Ubuntu 18.04+ / Debian 10+ |
| Privileges | Root or sudo access |
| Disk Space | 100 MB free |
| Network | SSH access |

---

## 📚 What You'll Learn

Running this script teaches you:
- ✅ SSH security hardening
- ✅ Fail2ban configuration
- ✅ UFW firewall management
- ✅ Linux service management
- ✅ Security best practices
- ✅ Brute-force attack prevention

---

## 🔐 Security Best Practices

After running this script:

1. **Monitor Logs** - Check for attacks
   ```bash
   sudo tail -f /var/log/auth.log
   sudo fail2ban-client status sshd
   ```

2. **Keep Updated** - Regular security updates
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

3. **Use Strong Passwords** - If using password auth
   ```bash
   passwd
   ```

4. **Backup Configs** - Keep backups of configurations
   ```bash
   sudo cp -r /etc/ssh ~/ssh-backup
   sudo cp -r /etc/fail2ban ~/fail2ban-backup
   ```

---

## 🚨 What This Protects Against

- **Brute-Force Attacks** - Fail2ban blocks repeated failed attempts
- **Port Scanning** - Non-standard SSH port reduces visibility
- **Unauthorized Access** - Firewall blocks unnecessary traffic
- **Weak Passwords** - Encourages strong password setup
- **Default Configurations** - Hardens default security settings

---

## 📊 Monitoring After Setup

### Check Fail2ban Status
```bash
sudo fail2ban-client status sshd
```

Output example:
```
Status for the jail sshd:
|- Filter
|  |- Currently failed: 0
|  |- Total failed: 5
|  `- File list: /var/log/auth.log
`- Actions
   |- Currently banned: 1
   |- Total banned: 3
   `- Banned IP list: 192.168.1.100
```

### Check Firewall Status
```bash
sudo ufw status verbose
```

### View Recent Bans
```bash
sudo grep "Ban" /var/log/fail2ban.log | tail -10
```

---

## 🔄 Updating SSH Port Later

If you need to change the SSH port again:

```bash
# Edit SSH config
sudo nano /etc/ssh/sshd_config
# Change: Port 41200 to Port XXXX

# Edit systemd socket
sudo systemctl edit ssh.socket
# Update ListenStream ports

# Validate and restart
sudo sshd -t
sudo systemctl restart ssh
sudo systemctl restart ssh.socket
```

---

## 🆘 Support & Troubleshooting

### Common Issues

**Issue: "Permission denied" when running script**
```bash
# Solution: Make script executable
chmod +x setup.sh
```

**Issue: "sudo: command not found"**
```bash
# Solution: Run with full path
/usr/bin/sudo ./setup.sh
```

**Issue: Can't connect after running**
```bash
# Solution: Check new SSH port
ssh -p 41200 user@your-vps-ip
```

**Issue: Fail2ban not banning IPs**
```bash
# Solution: Check if enabled
sudo fail2ban-client status sshd
sudo systemctl restart fail2ban
```

### Getting Help

1. Check the logs: `sudo tail -f /var/log/fail2ban.log`
2. Verify services: `sudo systemctl status ssh fail2ban ufw`
3. Test SSH config: `sudo sshd -t`
4. Check firewall: `sudo ufw status`

---

## 📖 Additional Resources

- [SSH Security Guide](https://linux.die.net/man/5/sshd_config)
- [Fail2ban Documentation](https://www.fail2ban.org/)
- [UFW Firewall Guide](https://help.ubuntu.com/community/UFW)
- [Linux Security Best Practices](https://www.cyberciti.biz/tips/linux-security.html)

---

## 📄 License

This script is provided as-is for educational and security hardening purposes.

---

## 👨‍💻 Author

**Sujaul Islam**
- GitHub: [@Thepotatostealer-code](https://github.com/Thepotatostealer-code)
- LinkedIn: [Sujaul Islam](https://www.linkedin.com/in/sujaul-islam-ahil-b91b94344/)
- Email: sujaul.islam.ahil@gmail.com

---

## 🙏 Contributing

Found a bug? Have suggestions? Feel free to:
1. Open an issue
2. Submit a pull request
3. Share feedback

---

## ⭐ If This Helped You

If this script was useful, please:
- ⭐ Star the repository
- 🔗 Share with others
- 💬 Leave feedback
- 📢 Mention it in your projects

---

## 📝 Changelog

### Version 1.0 (Initial Release)
- SSH hardening automation
- Fail2ban configuration
- UFW firewall setup
- Password management
- Configuration validation
- Error handling

---

## ⚡ Quick Reference

```bash
# Make executable
chmod +x setup.sh

# Run script
sudo ./setup.sh

# Check Fail2ban status
sudo fail2ban-client status sshd

# Check firewall
sudo ufw status

# Connect with new port
ssh -p 41200 user@your-vps-ip

# View recent bans
sudo grep "Ban" /var/log/fail2ban.log

# Restart services
sudo systemctl restart ssh fail2ban
```

---

**Your VPS is now secured! 🔒**
