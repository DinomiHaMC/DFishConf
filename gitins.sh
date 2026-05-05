#!/bin/bash

cd ~/
# Скачиваем yay - установщик++
sudo pacman -S --noconfirm --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm

cd ~/

# Полезные программы
yay -S --noconfirm lsd btop fastfetch lazygit bat neovim ntfs-3g lazyssh openssh lazydocker docker python zoxide superfiles fish

# Запрет
git clone https://github.com/Sergeydigl3/zapret-discord-youtube-linux.git
mv zapret-discord-youtube-linux zap

~/zap/service.sh download-deps --default

# Установка fish в .bashrc (больше так не буду)
echo "fish" | sudo tee -a ~/.bashrc

# Установка LazyVim
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

# Установка настроек на fish
cd ~/DFishC
cp -r fish ~/.config
cp -r fastfetch ~/.config
