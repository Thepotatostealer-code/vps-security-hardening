# Quick Start Guide - VPS Security Hardening Script

Get your VPS secured in 5 minutes!

---

## Step 1: Download the Script

### Option A: Clone the Repository
```bash
git clone https://github.com/Thepotatostealer-code/vps-security-hardening.git
cd vps-security-hardening
```

### Option B: Download Single File
```bash
wget https://raw.githubusercontent.com/Thepotatostealer-code/vps-security-hardening/main/setup.sh
```

---

## Step 2: Make Script Executable

```bash
chmod +x setup.sh
```

**What this does:**
- `chmod` = change file mode/permissions
- `+x` = add execute permission
- `setup.sh` = the script file

**Why you need it:**
- By default, scripts aren't executable for security
- This permission allows the script to run

---

## Step 3: Run the Script

```bash
sudo ./setup.sh
```

**What this does:**
- `sudo` = run with root privileges (required for security changes)
- `./` = run from current directory
- `setup.sh` = the script file

**What you'll see:**
```
Entering setup script...
Enter New SSH Port: 
```

---

## Step 4: Answer the Prompts

### Prompt 1: Enter New SSH Port
```
Enter New SSH Port: 41200
```
- Default SSH port is 22 (commonly attacked)
- Choose a port between 1024-65535
- **Recommended:** 41200, 2222, 10022, or any random high port
- **Remember this port!** You'll need it to connect later

### Prompt 2: Enter SSH Fail Attempts
```
Enter SSH Fail Attempts: 5
```
- How many failed login attempts before banning
- **Recommended:** 5 (ban after 5 failed attempts)
- Lower = stricter, Higher = more lenient

### Prompt 3: Enter SSH Ban Time
```
Enter SSH Ban Time (in seconds): 3600
```
- How long to ban an IP after failed attempts
- 3600 = 1 hour, 86400 = 1 day
- **Recommended:** 3600 (1 hour)

### Prompt 4: Change Password?
```
Do you want to change the password for the current user? (yes/no): yes
```
- Type `yes` to change password
- Type `no` to skip
- **Recommended:** yes (use strong password)

If yes, enter new password:
```
Enter new password: ••••••••
```

---

## Step 5: Wait for Script to Complete

The script will:
1. ✅ Update system packages
2. ✅ Install Fail2ban
3. ✅ Configure Fail2ban
4. ✅ Change SSH port
5. ✅ Setup UFW firewall
6. ✅ Restart services
7. ✅ Validate everything

**You'll see:**
```
Updating system packages...
Installing Fail2Ban...
Configuring Fail2Ban...
Restarting Fail2Ban service...
Checking Fail2Ban status...
Fail2Ban is configured correctly.
Changing SSH port to 41200...
Setting up firewall rules...
Restarting SSH service...
SSH port changed to 41200, Firewall setup and Fail2Ban configured successfully.
```

---

## Step 6: Done! ✅

Your VPS is now secured with:
- ✅ SSH hardening (custom port)
- ✅ Fail2ban (brute-force protection)
- ✅ UFW firewall (network protection)
- ✅ Strong password (if changed)

---

## 🔗 Connect to Your VPS After Setup

**Important:** You must use the new SSH port!

```bash
ssh -p 41200 user@your-vps-ip
```

Replace:
- `41200` with your chosen SSH port
- `user` with your username
- `your-vps-ip` with your VPS IP address

**Example:**
```bash
ssh -p 41200 ubuntu@192.168.1.100
```

---

## ✅ Verify Everything Works

### Check Fail2ban Status
```bash
sudo fail2ban-client status sshd
```

**Expected output:**
```
Status for the jail sshd:
|- Filter
|  |- Currently failed: 0
|  |- Total failed: 0
|  `- File list: /var/log/auth.log
`- Actions
   |- Currently banned: 0
   |- Total banned: 0
   `- Banned IP list:
```

### Check Firewall Status
```bash
sudo ufw status
```

**Expected output:**
```
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
41200/tcp                  ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
41200/tcp (v6)             ALLOW       Anywhere (v6)
```

### Check SSH Service
```bash
sudo systemctl status ssh
```

**Expected output:**
```
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2024-01-15 10:30:00 UTC; 2min ago
```

---

## 🚨 Troubleshooting

### Problem: "Permission denied"
```bash
# Solution: Make script executable
chmod +x setup.sh
```

### Problem: Can't connect to VPS
```bash
# Solution 1: Use correct port
ssh -p 41200 user@your-vps-ip

# Solution 2: Check if SSH is running
sudo systemctl status ssh

# Solution 3: Check firewall allows your port
sudo ufw status
```

### Problem: Fail2ban not working
```bash
# Check status
sudo fail2ban-client status sshd

# Restart service
sudo systemctl restart fail2ban

# View logs
sudo tail -f /var/log/fail2ban.log
```

### Problem: Can't run with sudo
```bash
# Make sure you have sudo access
sudo whoami

# If not, try:
su -
./setup.sh
```

---

## 📊 What Got Configured

### SSH Port Changed
- **From:** 22 (default, commonly attacked)
- **To:** Your chosen port (e.g., 41200)

### Fail2ban Configured
- **Monitors:** SSH login attempts
- **Action:** Bans IP after X failed attempts
- **Duration:** Ban time you specified

### Firewall Enabled
- **Allows:** Port 22 and your custom SSH port
- **Blocks:** All other incoming traffic
- **Status:** Active and protecting

---

## 🔐 Security Tips

1. **Remember Your SSH Port** - You'll need it to connect
2. **Use SSH Keys** - More secure than passwords
3. **Keep Updated** - Run `sudo apt update && sudo apt upgrade -y`
4. **Monitor Logs** - Check for attacks: `sudo tail -f /var/log/auth.log`
5. **Backup Config** - Save your configurations

---

## 📝 Important Notes

- ✅ Script is safe and tested
- ✅ Creates backups automatically
- ✅ Validates all changes
- ✅ Handles errors gracefully
- ⚠️ Requires root/sudo access
- ⚠️ Changes network configuration
- ⚠️ Restarts SSH service (brief disconnection)


## 🆘 Need Help?

1. **Check README.md** - Full documentation
2. **View logs** - `sudo tail -f /var/log/fail2ban.log`
3. **Test SSH config** - `sudo sshd -t`
4. **Check services** - `sudo systemctl status ssh fail2ban ufw`

---

## ⚡ Quick Reference

```bash
# Make executable
chmod +x setup.sh

# Run script
sudo ./setup.sh

# Connect with new port
ssh -p 41200 user@your-vps-ip

# Check Fail2ban
sudo fail2ban-client status sshd

# Check firewall
sudo ufw status

# View bans
sudo grep "Ban" /var/log/fail2ban.log

# Restart services
sudo systemctl restart ssh fail2ban
```

---

**Your VPS is now secured! 🔒**

For detailed information, see the full README.md
