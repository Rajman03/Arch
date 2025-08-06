sudo pacman -S gnome gnome-extra gdm pipewire pipewire-pulse wireplumber \
networkmanager gnome-tweaks gnome-shell-extensions \
ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji \
file-roller gvfs gvfs-mtp gvfs-smb \
xdg-user-dirs gnome-keyring seahorse \
cups system-config-printer power-profiles-daemon firefox neofetch

# 1. Instalacja uzupełniających pakietów (jeśli ich nie masz)
sudo pacman -S --needed --noconfirm \
gnome-tweaks gnome-shell-extensions gnome-keyring seahorse \
ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji \
file-roller gvfs gvfs-mtp gvfs-smb \
xdg-user-dirs cups system-config-printer \
power-profiles-daemon firefox neofetch

# 2. Włączenie usług (jeśli jeszcze nie są aktywne)
sudo systemctl enable NetworkManager --now
sudo systemctl enable cups --now

# 3. Aktualizacja domyślnych katalogów (Obrazy, Dokumenty itd.)
xdg-user-dirs-update

# 4. Dodanie neofetch do ~/.bashrc (jeśli nie ma)
grep -qxF 'neofetch' ~/.bashrc || echo 'neofetch' >> ~/.bashrc

# 5. Włączenie rozszerzenia Dash to Dock i konfiguracja docka jako stałego
gnome-extensions enable dash-to-dock@micxgx.gmail.com
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false
