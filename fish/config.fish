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
    alias cat='bat'
    alias home='cd ~'
    alias dc='cd'
    alias hom='home'
    alias hm='home'

    #neovim
    alias nv='nvim'
    alias nvf='nv ~/.config/fish/config.fish'
    alias nvn='nv ~/.config/niri/config.kdl'

    #disks
    alias startd='sudo ntfs-3g /dev/sdb1 /mnt/d'

    #pacman
    alias pac='sudo pacman'
    alias paci='pac -S --noconfirm'
    alias pacs='pac -S'
    alias pacr='pac -R'
    alias pacq='pac -Qe'
    alias pacu='pac -U'

    #yay
    alias yay='yay'
    alias ya='yay'
    alias ys='ya -S'
    alias yr='ya -R'
    alias yu='ya -U'
    alias yi='ys --noconfirm'
    alias yq='ya -Qe'
    alias yupd='ya -Syu --noconfirm'

    #lazyTUI
    alias lssh='lazyssh'
    alias lg='lazygit'
    alias ldoc='lazydocker'

    #python
    alias py='python'
    alias pyi='pip install --break-system-packages'

    #openclaude
    alias occ="bun run --cwd=/home/dmh/openclaude dev:openai"

    #setup
    zoxide init fish | source

    #zapret
    alias fix='~/zap/service.sh service start'
    alias fixs='~/zap/service.sh service stop'

    ff
end
