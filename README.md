# DinoMiHa`s Fish Config


### Работает на дистрибутивах linux arch / arch-based

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

cat - bat

home - cd ~

dc - cd

hom - cd ~

hm - cd ~

occ - openclaude (сам не скачивается, работает если в ~/openclaude)

-----------------------
- neovim

nv - nvim

nvf - nv ~/.config/config.fish (открыть настройки fish)

nvn - nv ~/.config/niri/config.kdl (открыть настройки niri)

-----------------------
- pacman

pac - sudo pacman

paci - pacman -S --noconfirm

pacs - pacman -S

pacr - pacman -R

pacq - pacman -Qe

pacu - pacman -U

-----------------------
- yay

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

-----------------------
- zapret

fix - ~/zap/service.sh service start

fixs - ~/zap/service.sh service stop

-----------------------
- ffinder

\\ <ЗАПРОС В GOOGLE>
Создает окно firefox с вашим запросом
