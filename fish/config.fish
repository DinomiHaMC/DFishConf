if status is-interactive
    set TERM xterm-256-color

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
        alias bt='bat'
    else if command -q batcat
        alias bt='batcat'
    end
    alias home='cd ~'
    alias dc='cd'
    alias hom='home'
    alias hm='home'
    alias rm='rm -rf'
    alias mk='mkdir'
    alias md='mkdir'

    #git
    alias gc='git clone'
    alias ga='git add'
    alias gal='ga *'
    alias gcm='git commit -m'
    alias gp='git push'
    alias gin='git init'

    #neovim
    alias nv='nvim'
    alias nvf='nv ~/.config/fish/config.fish'
    alias nvn='nv ~/.config/niri/config.kdl'
    alias snv='sudo nvim'

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
        alias ai='sudo apt install -y'
        alias as='sudo apt install'
        alias ar='sudo apt remove'
        alias aq='apt list --installed'
        alias au='sudo apt update && sudo apt upgrade -y'

        alias apt='sudo apt'
        alias apti='apti'
        alias apts='apts'
        alias aptr='aptr'
        alias aptq='aptq'
        alias aptu='aptu'
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

    #ffinder
    function \\
        nohup firefox --new-window "https://www.google.com/search?q=$argv" >/dev/null
    end

    #setup
    command -q zoxide; and zoxide init fish | source

    #zapret
    alias fix='zap/service.sh run -s "general (ALT).bat"'

    #shutdown
    alias shn='shutdown now'

    #reboot
    alias rbt='reboot'

    command -q fastfetch; and ff
end
fish_add_path $HOME/.local/bin
