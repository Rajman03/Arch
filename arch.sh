#!/bin/bash
# Instalator Hyprland dla Arch Linux (Intel GPU + SDDM autostart Hyprland + motyw sugar-dark)
# Uruchamiaj jako zwykły user (NIE root)

set -e

echo "=== Aktualizacja systemu ==="
sudo pacman -Syu --noconfirm

echo "=== Instalacja podstawowych narzędzi ==="
sudo pacman -S --noconfirm base-devel git wget curl unzip \
    nano neovim htop

echo "=== Instalacja sterowników Intel ==="
sudo pacman -S --noconfirm mesa libva-intel-driver vulkan-intel

echo "=== Instalacja Hyprland i narzędzi ==="
sudo pacman -S --noconfirm hyprland \
    xdg-desktop-portal-hyprland xdg-desktop-portal xdg-desktop-portal-gtk \
    waybar rofi wl-clipboard grim slurp hyprpaper brightnessctl pamixer \
    alacritty thunar thunar-volman gvfs polkit-gnome \
    pipewire pipewire-alsa pipewire-pulse wireplumber \
    dunst udiskie blueman network-manager-applet

echo "=== Instalacja i włączenie SDDM ==="
sudo pacman -S --noconfirm sddm
sudo systemctl enable sddm

echo "=== Instalacja motywu SDDM sugar-dark ==="
git clone https://github.com/MarianArlt/sddm-sugar-dark.git /tmp/sddm-sugar-dark
sudo mkdir -p /usr/share/sddm/themes/sugar-dark
sudo cp -r /tmp/sddm-sugar-dark/* /usr/share/sddm/themes/sugar-dark
sudo rm -rf /tmp/sddm-sugar-dark

echo "=== Ustawienie motywu sugar-dark jako domyślnego ==="
sudo mkdir -p /etc/sddm.conf.d
cat <<EOF | sudo tee /etc/sddm.conf.d/theme.conf
[Theme]
Current=sugar-dark
EOF

echo "=== Tworzenie pliku sesji dla Hyprland ==="
sudo mkdir -p /usr/share/wayland-sessions
sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null <<'EOF'
[Desktop Entry]
Name=Hyprland
Comment=Hyprland Wayland Compositor
Exec=Hyprland
Type=Application
EOF

echo "=== Ustawianie Hyprland jako domyślnej sesji dla użytkownika ==="
mkdir -p ~/.config
echo "Hyprland" > ~/.config/sddm.conf.session

echo "=== Tworzenie katalogów konfiguracyjnych ==="
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/rofi ~/Obrazy

echo "=== Tworzenie configu Hyprland ==="
cat > ~/.config/hypr/hyprland.conf <<'EOF'
monitor=,preferred,auto,auto

exec = waybar
exec = hyprpaper
exec = alacritty
exec-once = dunst
exec-once = nm-applet
exec-once = udiskie -t

$mod = SUPER

bind = $mod, RETURN, exec, alacritty
bind = $mod, Q, killactive,
bind = $mod, M, exit,
bind = $mod, E, exec, thunar
bind = $mod, V, togglefloating,
bind = $mod, F, fullscreen
EOF

echo "=== Tworzenie configu Hyprpaper ==="
cat > ~/.config/hypr/hyprpaper.conf <<'EOF'
preload = ~/Obrazy/tapeta.png
wallpaper = ,~/Obrazy/tapeta.png
EOF

echo "=== Dodawanie przykładowej tapety ==="
wget -O ~/Obrazy/tapeta.png https://archlinux.org/static/logos/archlinux-logo-dark-90dpi.ebdee92a15b3.png

echo "=== Tworzenie configu Waybar ==="
cat > ~/.config/waybar/config.jsonc <<'EOF'
{
  "layer": "top",
  "modules-left": ["clock"],
  "modules-center": ["workspaces"],
  "modules-right": ["pulseaudio", "network", "battery"],
  "clock": { "format": "%H:%M:%S" },
  "pulseaudio": { "format": " {volume}%" },
  "network": { "format": "{ifname}: {ipaddr}" },
  "battery": { "format": "{capacity}% {icon}" }
}
EOF

echo "=== Instalacja zakończona! ==="
echo "Po restarcie zobaczysz ekran logowania SDDM z motywem sugar-dark."
echo "Po wpisaniu loginu i hasła Hyprland wystartuje automatycznie."
