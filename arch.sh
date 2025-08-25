# 1. Aktualizacja systemu
sudo apt update && sudo apt upgrade -y

# 2. Instalacja Samby
sudo apt install samba -y

# 3. Tworzenie katalogu w katalogu domowym
sudo mkdir -p /home/OneDrive
sudo chown nobody:nogroup /home/OneDrive
sudo chmod 2775 /home/OneDrive

# 4. Dodanie udziału do konfiguracji Samby
sudo bash -c 'cat >> /etc/samba/smb.conf <<EOL

[OneDrive]
   path = /home/OneDrive
   browsable = yes
   writable = yes
   guest ok = yes
   read only = no
   force create mode = 0660
   force directory mode = 2770
EOL'

# 5. Tworzenie użytkownika Samby rajman
sudo useradd -M rajman -s /sbin/nologin
(echo "haslo123"; echo "haslo123") | sudo smbpasswd -s -a rajman

# 6. Restart Samby i włączenie przy starcie
sudo systemctl restart smbd
sudo systemctl enable smbd

# 7. Sprawdzenie konfiguracji
testparm
