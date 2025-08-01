#!/bin/bash

echo "🛠️  Instalacja wymaganych pakietów..."
sudo apt update
sudo apt install -y gnome-tweaks gnome-shell-extensions chrome-gnome-shell arc-theme papirus-icon-theme gnome-terminal

echo "📁 Tworzenie katalogów na motywy i ikony..."
mkdir -p ~/.themes ~/.icons

echo "🎨 Ustawianie motywu GTK, ikon i shell..."
gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'
gsettings set org.gnome.desktop.wm.preferences theme 'Arc-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

echo "🧩 Włączanie rozszerzenia User Themes..."
gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com 2>/dev/null || echo "⚠️  Włącz rozszerzenie User Themes ręcznie przez Tweaks!"

gsettings set org.gnome.shell.extensions.user-theme name 'Arc-Dark'

echo "⌨️  Dodawanie skrótu Ctrl+Alt+T do terminala..."

CUSTOM_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$CUSTOM_PATH']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_PATH name 'Terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_PATH command 'gnome-terminal'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_PATH binding '<Control><Alt>T'

echo "✅ Gotowe! Uruchom ponownie GNOME Tweaks lub sesję, by zobaczyć zmiany."
