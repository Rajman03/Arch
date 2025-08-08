#!/bin/bash
set -e

echo "[*] Tworzenie własnego profilu ISO Arch Linux..."

# === 1. Katalog bazowy ===
mkdir -p ~/iso-build
cd ~/iso-build
cp -r /usr/share/archiso/configs/releng customiso
cd customiso

# === 2. Lista pakietów ===
cat > packages.x86_64 <<EOF
base
linux
linux-firmware
mkinitcpio
mkinitcpio-archiso
xorg-server
xorg-apps
plasma
sddm
konsole
dolphin
kate
ark
networkmanager
sudo
calamares
qt5-base
qt5-declarative
qt5-quickcontrols2
qt5-svg
kpmcore
parted
grub
os-prober
EOF

# === 3. Tworzenie liveusera ===
mkdir -p airootfs/etc
echo "liveuser ALL=(ALL) NOPASSWD: ALL" > airootfs/etc/sudoers.d/liveuser

mkdir -p airootfs/etc/skel

cat > airootfs/etc/passwd <<EOF
root:x:0:0:root:/root:/bin/bash
liveuser:x:1000:1000:Live User:/home/liveuser:/bin/bash
EOF

cat > airootfs/etc/group <<EOF
root:x:0:
liveuser:x:1000:
wheel:x:10:liveuser
users:x:100:
EOF

cat > airootfs/etc/shadow <<EOF
root::14871::::::
liveuser::14871::::::
EOF

cat > airootfs/etc/gshadow <<EOF
root::::
liveuser::::
wheel:::liveuser
users:::liveuser
EOF

mkdir -p airootfs/home/liveuser
cp -r airootfs/etc/skel/. airootfs/home/liveuser
chmod 755 airootfs/home/liveuser

# === 4. Włącz usługi ===
cat > airootfs/root/customize_airootfs.sh <<'EOF'
#!/bin/bash
systemctl enable sddm
systemctl enable NetworkManager
EOF
chmod +x airootfs/root/customize_airootfs.sh

# === 5. Autostart Calamares w KDE ===
mkdir -p airootfs/etc/skel/.config/autostart

cat > airootfs/etc/skel/.config/autostart/calamares.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Calamares Installer
Exec=calamares
Icon=system-installer
Terminal=false
StartupNotify=true
EOF

# === 6. Konfiguracja Calamares ===
mkdir -p airootfs/etc/calamares

cat > airootfs/etc/calamares/settings.conf <<EOF
---
branding: custom
modules-search:
  - /etc/calamares/modules
sequence:
  - show:
      - welcome
      - locale
      - keyboard
      - partition
      - users
      - summary
      - install
      - finished
EOF

echo "[✔] Konfiguracja zakończona!"
echo "[→] Aby zbudować ISO, użyj:"
echo "     cd ~/iso-build/customiso"
echo "     sudo mkarchiso -v ./"
