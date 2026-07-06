# DinoMiHa`s Fish Config


### Работает на Arch/Arch-based и Debian/Ubuntu-based дистрибутивах Linux

### Скачать через cUrl: 
```
curl -LJO https://raw.githubusercontent.com/DinomiHaMC/DFishConf/refs/heads/main/ins.sh && bash ins.sh
```



### Через Git:
```
git clone https://github.com/DinomiHaMC/DFishConf.git ~/DFishC && bash ~/DFishC/ins.sh
```

После скачивания советую перезагрузится: ```reboot```

# Что же я скачал кроме ратника?

## Вместо bash будет стоять более красивый fish (я забыл как называется тема)


## Новые программы которые описаны в алиасах ниже


## Алиасы:
- ls

ls - lsd

l - lsd -l

la - lsd -a

lla - lsd -la

lt - lsd -tree

sl - lsd

-----------------------
- utils

mon - btop

ff - fastfetch

fff - fastfetch

f - fastfetch

lgit - lazygit

sf - spf

bt - bat / batcat

home - cd ~

dc - cd

hom - cd ~

hm - cd ~

rm - rm -rf

mk - mkdir

md - mkdir

occ - openclaude (сам не скачивается, работает если в ~/openclaude)

-----------------------
- git

gc - git clone

ga - git add

gal - git add *

gcm - git commit -m

gp - git push

gin - git init

-----------------------
- neovim

nv - nvim

nvf - nv ~/.config/fish/config.fish (открыть настройки fish)

nvn - nv ~/.config/niri/config.kdl (открыть настройки niri)

snv - sudo nvim

-----------------------
- packages

На Arch/Arch-based алиасы используют `pacman`, на Debian/Ubuntu-based - `apt`.

pac - sudo pacman / sudo apt

paci - pacman -S --noconfirm / apt install -y

pacs - pacman -S / apt install

pacr - pacman -R / apt remove

pacq - pacman -Qe / apt list --installed

pacu - pacman -U

pacupd - pacman -Syu / apt update && apt upgrade -y

ai - sudo apt install -y

as - sudo apt install

ar - sudo apt remove

aq - apt list --installed

au - sudo apt update && sudo apt upgrade -y

-----------------------
- flatpak

fp - flatpak

fpi - flatpak install

fpr - flatpak remove

-----------------------
- yay

Работает только если установлен `yay`.

ya - yay

ys - yay -S

yr - yay -R

yu - yay -U

yi - yay -S --noconfirm

yq - yay -Qe

yupd - yay -Syu --noconfirm

-----------------------
- lazyTUI

lssh - lazyssh

lg - lazygit

ldoc - lazydocker

-----------------------
- python

py - python

pyi - pip install --break-system-packages

pyir - pip install --break-system-packages -r requirements.txt

-----------------------
- zapret

fix - zap/service.sh run -s "general (ALT).bat"

-----------------------
- system

shn - shutdown now

rbt - reboot

-----------------------
- ffinder

\\ <ЗАПРОС В GOOGLE>
Создает окно firefox с вашим запросом
