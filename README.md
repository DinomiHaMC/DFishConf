# DFishC

Мой набор настроек для `fish` и быстрый установщик рабочего окружения под Linux.

Репозиторий содержит:

- конфиг `fish` с алиасами, путями и автозапуском `fastfetch`;
- файлы `fisher` и темы `tide`: плагины, completions, functions и init-скрипт;
- установочный скрипт `ins.sh`;
- сортировщик загрузок `DSort.sh`.

## Поддерживаемые системы

`ins.sh` умеет определять и обслуживать:

- Arch/Arch-based дистрибутивы через `pacman` и, при необходимости, `yay`;
- Debian/Ubuntu-based дистрибутивы через `apt`;
- NixOS через `nix profile install` и подсказки для `configuration.nix`.

Если система не определена, скрипт предложит продолжить без distro-specific установки пакетов.

## Установка

Через `curl`:

```bash
curl -LJO https://raw.githubusercontent.com/DinomiHaMC/DFishConf/refs/heads/main/ins.sh
bash ins.sh
```

Через `git`:

```bash
git clone https://github.com/DinomiHaMC/DFishConf.git ~/DFishC
bash ~/DFishC/ins.sh
```

Скрипт работает интерактивно. Можно выбрать автоустановку или вручную подтвердить отдельные шаги.

После установки лучше перелогиниться или перезагрузиться:

```bash
reboot
```

## Что делает `ins.sh`

В зависимости от выбранного режима скрипт может:

- установить базовые программы для терминала;
- установить `yay` на Arch/Arch-based системах;
- скачать и настроить zapret в `~/zap`;
- установить LazyVim в `~/.config/nvim`;
- скопировать `config.fish`, `fish_variables`, `fish_plugins`, `conf.d`, `completions` и `functions` в `~/.config/fish`;
- добавить запуск `fish` вместо `bash`;
- скопировать `DSort.sh` в домашнюю директорию;
- показать пример декларативной настройки для NixOS.

На NixOS смена shell и включение Docker лучше выполняются через `/etc/nixos/configuration.nix`, поэтому скрипт выводит готовую подсказку.

## Устанавливаемые программы

Arch/Arch-based:

- `git`, `base-devel`, `fish`, `zoxide`;
- `lsd`, `btop`, `fastfetch`, `bat`;
- `lazygit`, `neovim`;
- `ntfs-3g`, `openssh`, `docker`;
- `python`, `python-pip`;
- через `yay`: `lazyssh`, `lazydocker`, `superfile`.

Debian/Ubuntu-based:

- `ca-certificates`, `curl`, `git`, `fish`, `zoxide`;
- `lsd`, `btop`, `fastfetch`, `bat`;
- `lazygit`, `neovim`;
- `ntfs-3g`, `openssh-client`, `openssh-server`, `docker.io`;
- `python3`, `python3-pip`, `python-is-python3`.

`lazyssh`, `lazydocker` и `superfile` могут отсутствовать в apt-репозиториях. Скрипт предупредит об этом.

NixOS:

- `git`, `fish`, `neovim`, `fastfetch`;
- `btop`, `bat`, `lsd`, `lazygit`;
- `openssh`, `docker`, `python3`, `pip`;
- `ntfs3g`, `zoxide`.

## Конфиг fish

Конфиг добавляет в `PATH`:

- `~/.local/bin`;
- `~/.nix-profile/bin`;
- `/nix/var/nix/profiles/default/bin`;
- `/run/current-system/sw/bin`;
- `/run/wrappers/bin`.

Основные особенности:

- `TERM` выставляется в `xterm-256color`;
- есть быстрые переключатели `kit` и `clr` для запуска команд с нужным `TERM`;
- есть alias `proxy` для запуска команд с HTTP/HTTPS proxy `127.0.0.1:10809`;
- алиасы включаются только если нужная команда установлена;
- `zoxide` инициализируется автоматически, если установлен;
- `fastfetch` запускается при открытии интерактивной fish-сессии.

## Алиасы

### ls

Если установлен `lsd`:

```fish
ls  -> lsd
sl  -> lsd
```

Дополнительно:

```fish
l   -> ls -l
la  -> ls -a
lla -> ls -la
lt  -> ls --tree
```

### Утилиты

```fish
nano -> TERM=xterm-256color nano
na   -> nano
sna  -> sudo nano
sy   -> sudo y
mon  -> btop
ff   -> fastfetch
fff  -> ff
f    -> ff
sf   -> spf
bt   -> bat / batcat
home -> cd ~
dc   -> cd
hom  -> home
hm   -> home
rm   -> rm -rf
mk   -> mkdir -p
md   -> mkdir -p
```

### Git

```fish
gc  -> git clone
ga  -> git add
gal -> git add .
gcm -> git commit -m
gp  -> git push
gin -> git init
```

### Neovim

Если установлен `nvim`:

```fish
nv  -> TERM=xterm-kitty nvim
nvf -> nv ~/.config/fish/config.fish
nvn -> nv ~/.config/niri/config.kdl
snv -> TERM=xterm-kitty sudo nvim
```

### Nix / NixOS

Если установлен `nix`:

```fish
nx   -> nix
ns   -> nix search nixpkgs
ni   -> nix profile install nixpkgs#
nr   -> nix profile remove
nl   -> nix profile list
nu   -> nix profile upgrade --all
nd   -> nix develop
nsh  -> nix shell nixpkgs#
nf   -> nix flake
nfu  -> nix flake update
ngc  -> nix store gc
ngcd -> nix-collect-garbage -d
```

Если доступен `nixos-rebuild`:

```fish
nrs -> sudo nixos-rebuild switch
nrb -> sudo nixos-rebuild boot
nrt -> sudo nixos-rebuild test
nrc -> sudo nvim /etc/nixos/configuration.nix
nrh -> sudo nvim /etc/nixos/hardware-configuration.nix
```

Если установлен `nh`:

```fish
nhs -> nh os switch
nhb -> nh os boot
nhc -> nh clean all
```

Если установлен `home-manager`:

```fish
hms -> home-manager switch
hme -> nvim ~/.config/home-manager/home.nix
```

### Пакеты

Arch/Arch-based:

```fish
pac    -> sudo pacman
paci   -> sudo pacman -S --noconfirm
pacs   -> sudo pacman -S
pacr   -> sudo pacman -R
pacq   -> pacman -Qe
pacu   -> sudo pacman -U
pacupd -> sudo pacman -Syu
```

Debian/Ubuntu-based:

```fish
ai   -> sudo apt install -y
as   -> sudo apt install
ar   -> sudo apt remove
aq   -> apt list --installed
au   -> sudo apt update && sudo apt upgrade -y
apti -> sudo apt install -y
apts -> sudo apt install
aptr -> sudo apt remove
aptq -> apt list --installed
aptu -> sudo apt update && sudo apt upgrade -y
```

Flatpak:

```fish
fp  -> flatpak
fpi -> flatpak install
fpr -> flatpak remove
```

yay:

```fish
ya   -> yay
ys   -> yay -S
yr   -> yay -R
yu   -> yay -U
yi   -> yay -S --noconfirm
yq   -> yay -Qe
yupd -> yay -Syu --noconfirm
```

### Lazy TUI

```fish
lssh -> TERM=xterm-kitty lazyssh
lg   -> TERM=xterm-kitty lazygit
ldoc -> TERM=xterm-kitty lazydocker
```

### Python

```fish
py   -> python / python3
pyi  -> pip install / pip3 install
pyir -> pyi -r requirements.txt
```

### Остальное

```fish
occ      -> ~/openclaude/bin/openclaude
Telegram -> proxy Telegram
fix      -> ~/zap/service.sh run -s 'general (ALT).bat'
shn      -> shutdown now
rbt      -> reboot
```

`occ` появляется только если файл `~/openclaude/bin/openclaude` существует и исполняемый.

`fix` появляется только если есть `~/zap/service.sh`.

## Поиск через Firefox

В fish доступна функция:

```fish
ffinder <запрос>
```

Она открывает новое окно Firefox с поиском Google по переданному запросу.

## DSort.sh

`DSort.sh` сортирует содержимое `~/Downloads` по папкам в домашней директории:

- аудио -> `~/Audios`;
- изображения -> `~/Pictures`;
- видео -> `~/Videos`;
- код и скрипты -> `~/Code`;
- всё остальное -> `~/Docs`.

При первом запуске скрипт создаёт папки `Downloads`, `Audios`, `Docs`, `Pictures`, `Videos`, `Code` и файл-флаг `~/.dirs-exists-flag`.

## Лицензия

См. [LICENSE](LICENSE).
