if status is-interactive

    #ls
    alias ls='lsd'
    alias l='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lt='ls --tree'
    alias sl='lsd'

    #ulils
    alias mon='btop'
    alias ff='fastfetch'
    alias fff='ff'
    alias f='ff'
    alias lgit='lazygit'
    alias sf='spf'
    if command -q bat
        alias cat='bat'
    else if command -q batcat
        alias cat='batcat'
    end
    alias home='cd ~'
    alias dc='cd'
    alias hom='home'
    alias hm='home'
    alias rm='rm -rf'
    alias gc='git clone'
    alias mk='mkdir'
    alias md='mkdir'

    #neovim
    alias nv='nvim'
    alias nvf='nv ~/.config/fish/config.fish'
    alias nvn='nv ~/.config/niri/config.kdl'
    alias snv='sudo nvim'
    #disks
    alias startd='sudo ntfs-3g /dev/sdb1 /mnt/d'

    #packages
    if command -q pacman
        alias pac='sudo pacman'
        alias paci='pac -S --noconfirm'
        alias pacs='pac -S'
        alias pacr='pac -R'
        alias pacq='pac -Qe'
        alias pacu='pac -U'
        alias pacupd='pac -Syu'
    else if command -q apt
        alias apti='sudo apt install -y'
        alias apts='sudo apt install'
        alias aptr='sudo apt remove'
        alias aptq='apt list --installed'
        alias aptu='sudo apt update && sudo apt upgrade -y'

        alias pac='sudo apt'
        alias paci='apti'
        alias pacs='apts'
        alias pacr='aptr'
        alias pacq='aptq'
        alias pacupd='aptu'
    end

    #flatpak
    alias fp='flatpak'
    alias fpi='fp install'
    alias fpr='fp remove'

    #yay
    if command -q yay
        alias ya='yay'
        alias ys='ya -S'
        alias yr='ya -R'
        alias yu='ya -U'
        alias yi='ys --noconfirm'
        alias yq='ya -Qe'
        alias yupd='ya -Syu --noconfirm'
    end

    #lazyTUI
    alias lssh='lazyssh'
    alias lg='lazygit'
    alias ldoc='lazydocker'

    #python
    if command -q python
        alias py='python'
    else if command -q python3
        alias py='python3'
    end

    if command -q pip
        alias pyi='pip install --break-system-packages'
    else if command -q pip3
        alias pyi='pip3 install --break-system-packages'
    end
    alias pyir='pyi -r requirements.txt'

    #openclaude
    alias occ="$HOME/openclaude/bin/openclaude"

    alias vts='sudo modprobe v4l2loopback devices=2 video_nr=0,1 card_label="0,1" exclusive_caps=1,1'
    alias vts2='v4l2-ctl --list-devices && python ~/OpenSeeFace/facetracker.py'

    #ffinder
    function \\
        nohup firefox --new-window "https://www.google.com/search?q=$argv" >/dev/null
    end

    alias swms='setsid start-hyprland & setsid startx -- :2 vt2 &'

    #setup
    command -q zoxide; and zoxide init fish | source

    #zapret
    alias fix='~/zap/service.sh service start'
    alias fixs='~/zap/service.sh service stop'

    #shutdown
    alias shn='shutdown now'

    export CLAUDE_CODE_USE_OPENAI=1
    export OPENAI_API_KEY=sk-zxc
    export OPENAI_BASE_URL=http://192.168.1.74:5001/
    export OPENAI_MODEL=gpt-4o

    alias kdeee='# Сначала только композитор
WAYLAND_DISPLAY=wayland-2 \
XDG_RUNTIME_DIR=/run/user/$(id -u) \
dbus-run-session -- kwin_wayland --wayland-display wayland-2 &

sleep 3

# Потом Plasma поверх него
WAYLAND_DISPLAY=wayland-2 \
XDG_RUNTIME_DIR=/run/user/$(id -u) \
QT_QPA_PLATFORM=wayland \
plasmashell &'

    command -q fastfetch; and ff
end
fish_add_path $HOME/.local/bin
