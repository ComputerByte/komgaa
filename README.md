# Komga Installer
### For Swizzin installs
Komga Installation on Swizzin based systems

Installs nginx settings, systemctl file, and patches swizzin panel.

Run install.sh as sudo
```bash
sudo su -
wget "https://raw.githubusercontent.com/ComputerByte/komgaa/main/komgainstall.sh"
chmod +x ~/komgainstall.sh
~/komgainstall.sh
```

The log file should be located at ``/root/log/swizzin.log``.

# Uninstaller: 

```bash
sudo su -
wget "https://raw.githubusercontent.com/ComputerByte/komgaa/main/komgauninstall.sh"
chmod +x ~/komgauninstall.sh
~/komgauninstall.sh
```
