#!/bin/bash

read -p "Включить автоустановку? (yes/no): " answer

if [[ "$answer" == "yes" ]]; then
  # Скачиваем yay
  sudo pacman -S --noconfirm --needed git base-devel
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si --noconfirm

  cd -

  # Полезные программы
  yay -S --noconfirm lsd btop fastfetch lazygit bat neovim ntfs-3g lazyssh openssh lazydocker docker python zoxide superfiles fish

  # Запрет
  git clone https://github.com/Sergeydigl3/zapret-discord-youtube-linux.git ~/zap

  ~/zap/service.sh download-deps --default

  # Установка fish в .bashrc
  echo "fish" | sudo tee -a ~/.bashrc

  # Установка LazyVim
  rm -rf ~/.config/nvim

  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git

  # Установка настроек на fish
  read -p "Установить проект github? Не надо при установке через Git. (yes/no): " answer

  if [[ "$answer" == "yes" ]]; then
    git clone https://github.com/DinomiHaMC/DFishConf.git ~/DFishC
  fi

  cp -r ~/DFishC/fish ~/.config/
  cp -r ~/DFishC/fastfetch ~/.config/
  exit
fi

# Скачиваем yay
read -p "Установить yay? (yes/no): " answer

if [[ "$answer" == "yes" ]]; then
  sudo pacman -S --noconfirm --needed git base-devel
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay
  makepkg -si --noconfirm
  cd -
fi

# Полезные программы
yay -S --noconfirm lsd btop fastfetch lazygit bat neovim ntfs-3g lazyssh openssh lazydocker docker python zoxide superfiles fish

# Запрет
read -p "Установить запрет? (yes/no): " answer

if [[ "$answer" == "yes" ]]; then
  git clone https://github.com/Sergeydigl3/zapret-discord-youtube-linux.git ~/zap

  ~/zap/service.sh download-deps --default
fi

# Установка fish в .bashrc
echo "fish" | sudo tee -a ~/.bashrc

# Установка LazyVim
read -p "Установить LazyGit? (yes/no): " answer

if [[ "$answer" == "yes" ]]; then
  rm -rf ~/.config/nvim

  git clone https://github.com/LazyVim/starter ~/.config/nvim
  rm -rf ~/.config/nvim/.git
fi
# Установка настроек на fish
read -p "Установить конфиги проект github? Не надо при установке через Git. (yes/no): " answer

if [[ "$answer" == "yes" ]]; then
  git clone https://github.com/DinomiHaMC/DFishConf.git ~/DFishC
fi

cp -r ~/DFishC/fish ~/.config/
cp -r ~/DFishC/fastfetch ~/.config/
