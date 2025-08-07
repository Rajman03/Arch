sudo pacman -S --noconfirm tor proxychains-ng \
&& yay -S --noconfirm tor-browser \
&& sudo systemctl enable --now tor \
&& sudo sed -i 's/socks4.*/socks5 127.0.0.1 9050/' /etc/proxychains.conf \
&& source /etc/locale.conf
