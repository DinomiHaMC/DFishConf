# ~/.config/fish/config.fish

# Пути:
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.nix-profile/bin
fish_add_path /nix/var/nix/profiles/default/bin
fish_add_path /run/current-system/sw/bin
fish_add_path /run/wrappers/bin

if status is-interactive
    set -gx TERM xterm-256color

    alias kit='TERM=xterm-kitty'

    alias clr='TERM=xterm-256color'

    alias proxy='env HTTP_PROXY=http://127.0.0.1:10809 HTTPS_PROXY=http://127.0.0.1:10809 NO_PROXY=localhost,127.0.0.1'

    # ls
    if command -q lsd
        alias ls='lsd'
        alias sl='lsd'
    end

    alias l='ls -l'
    alias la='ls -a'
    alias lla='ls -la'
    alias lt='ls --tree'

    # utils
    alias nano='TERM=xterm-256color nano'
    alias na='nano'
    alias sna='sudo nano'
    
    alias sy='sudo y'

    command -q btop; and alias mon='btop'
    command -q fastfetch; and alias ff='fastfetch'
    alias fff='ff'
    alias f='ff'

    if command -q spf
        alias sf='spf'
    end

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
    alias mk='mkdir -p'
    alias md='mkdir -p'

    # git
    alias gc='git clone'
    alias ga='git add'
    alias gal='git add .'
    alias gcm='git commit -m'
    alias gp='git push'
    alias gin='git init'

    # neovim
    if command -q nvim
        alias nv='kit nvim'
        alias nvf='nv ~/.config/fish/config.fish'
        alias nvn='nv ~/.config/niri/config.kdl'
        alias snv='kit sudo nvim'
    end

    # Nix / NixOS
    if command -q nix
        alias nx='nix'
        alias ns='nix search nixpkgs'
        alias ni='nix profile install nixpkgs#'
        alias nr='nix profile remove'
        alias nl='nix profile list'
        alias nu='nix profile upgrade --all'
        alias nd='nix develop'
        alias nsh='nix shell nixpkgs#'
        alias nf='nix flake'
        alias nfu='nix flake update'
        alias ngc='nix store gc'
        alias ngcd='nix-collect-garbage -d'
    end

    if command -q nixos-rebuild
        alias nrs='sudo nixos-rebuild switch'
        alias nrb='sudo nixos-rebuild boot'
        alias nrt='sudo nixos-rebuild test'
        alias nrc='snv /etc/nixos/configuration.nix'
        alias nrh='snv /etc/nixos/hardware-configuration.nix'
    end

    if command -q nh
        alias nhs='nh os switch'
        alias nhb='nh os boot'
        alias nhc='nh clean all'
    end

    if command -q home-manager
        alias hms='home-manager switch'
        alias hme='nvim ~/.config/home-manager/home.nix'
    end

    # Arch
    if command -q pacman
        alias pac='sudo pacman'
        alias paci='sudo pacman -S --noconfirm'
        alias pacs='sudo pacman -S'
        alias pacr='sudo pacman -R'
        alias pacq='pacman -Qe'
        alias pacu='sudo pacman -U'
        alias pacupd='sudo pacman -Syu'
    end

    # Debian / Ubuntu
    if command -q apt
        alias ai='sudo apt install -y'
        alias as='sudo apt install'
        alias ar='sudo apt remove'
        alias aq='apt list --installed'
        alias au='sudo apt update && sudo apt upgrade -y'

        alias apti='sudo apt install -y'
        alias apts='sudo apt install'
        alias aptr='sudo apt remove'
        alias aptq='apt list --installed'
        alias aptu='sudo apt update && sudo apt upgrade -y'
    end

    # Flatpak
    if command -q flatpak
        alias fp='flatpak'
        alias fpi='flatpak install'
        alias fpr='flatpak remove'
    end

    # yay
    if command -q yay
        alias ya='yay'
        alias ys='yay -S'
        alias yr='yay -R'
        alias yu='yay -U'
        alias yi='yay -S --noconfirm'
        alias yq='yay -Qe'
        alias yupd='yay -Syu --noconfirm'
    end

    # lazy TUI
    command -q lazyssh; and alias lssh='kit lazyssh'
    command -q lazygit; and alias lg='kit lazygit'
    command -q lazydocker; and alias ldoc='kit lazydocker'

    # python
    if command -q python
        alias py='python'
    else if command -q python3
        alias py='python3'
    end

    if command -q pip
        alias pyi='pip install'
    else if command -q pip3
        alias pyi='pip3 install'
    end

    alias pyir='pyi -r requirements.txt'

    # openclaude
    if test -x "$HOME/openclaude/bin/openclaude"
        alias occ="$HOME/openclaude/bin/openclaude"
    end

    # browser search
    function ffinder
        set -l query (string join " " $argv)
        nohup firefox --new-window "https://www.google.com/search?q=$query" >/dev/null 2>&1 &
    end

    # zoxide
    command -q zoxide; and zoxide init fish | source
    
    alias Telegram='proxy Telegram'

    # zapret
    if test -f "$HOME/zap/service.sh"
        alias fix="$HOME/zap/service.sh run -s 'general (ALT).bat'"
    end

    # power
    alias shn='shutdown now'
    alias rbt='reboot'

    command -q fastfetch; and fastfetch
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/dmh/.lmstudio/bin
# End of LM Studio CLI section

