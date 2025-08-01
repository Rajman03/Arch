#!/bin/bash
# Automatyczna instalacja Arch Linux z Hyprland i Intel Iris Xe Graphics

set -e

DISK="/dev/sda"
HOSTNAME="arch-hypr"
USERNAME="rajman"
USER_PASSWORD="123"
ROOT_PASSWORD="haslo123"
LOCALE="pl_PL.UTF-8"
TIMEZONE="Europe/Warsaw"
KEYMAP="pl"

echo "==> Partycjonowanie dysku: $DISK"
sgdisk -Z $DISK
sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI" $DISK
sgdisk -n 2:0:0     -t 2:8300 -c 2:"Linux" $DISK

mkfs.fat -F32 ${DISK}1
mkfs.ext4 ${DISK}2

mount ${DISK}2 /mnt
mkdir /mnt/boot
mount ${DISK}1 /mnt/boot

echo "==> Instalacja bazowego systemu i sterowników Intel"
pacstrap /mnt base base-devel linux linux-firmware intel-ucode \
  mesa vulkan-intel intel-media-driver libva-intel-driver \
  sudo networkmanager vim git grub efibootmgr

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt /bin/bash <<EOF
echo "$HOSTNAME" > /etc/hostname

ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime
hwclock --systohc

sed -i "s/#$LOCALE UTF-8/$LOCALE UTF-8/" /etc/locale.gen
locale-gen
echo "LANG=$LOCALE" > /etc/locale.conf

echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf

echo "==> Instalacja i konfiguracja GRUB EFI"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "==> Tworzenie użytkownika: $USERNAME"
useradd -m -G wheel,video,audio,network -s /bin/bash $USERNAME
echo "$USERNAME:$USER_PASSWORD" | chpasswd
echo "root:$ROOT_PASSWORD" | chpasswd
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers

echo "==> Włączenie usług"
systemctl enable NetworkManager

echo "==> Instalacja Hyprland i aplikacji"
pacman -Syu --noconfirm \
  hyprland \
  xdg-desktop-portal-hyprland \
  xdg-desktop-portal \
  kitty \
  waybar \
  rofi \
  thunar \
  pipewire pipewire-pulse wireplumber \
  polkit \
  brightnessctl \
  network-manager-applet \
  ttf-font-awesome ttf-jetbrains-mono noto-fonts \
  swaybg grim slurp wl-clipboard \
  neofetch

echo "==> Konfiguracja Hyprland w katalogu domowym"
mkdir -p /home/$USERNAME/.config/hypr
chown -R $USERNAME:$USERNAME /home/$USERNAME/.config

echo '
#!/bin/bash
exec Hyprland
' > /home/$USERNAME/.xinitrc
chmod +x /home/$USERNAME/.xinitrc
chown $USERNAME:$USERNAME /home/$USERNAME/.xinitrc

echo "==> Ustawienie startu Hyprland po zalogowaniu"
echo '[[ -z \$DISPLAY && \$XDG_VTNR -eq 1 ]] && exec startx' >> /home/$USERNAME/.bash_profile
chown $USERNAME:$USERNAME /home/$USERNAME/.bash_profile

EOF

echo "✅ Instalacja zakończona. Uruchom ponownie i zaloguj się jako $USERNAME (hasło: $USER_PASSWORD), Hyprland uruchomi się automatycznie."
