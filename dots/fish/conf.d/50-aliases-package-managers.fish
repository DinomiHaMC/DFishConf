status is-interactive; or return

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

if command -q pacman
    alias pac='sudo pacman'
    alias paci='sudo pacman -S --noconfirm'
    alias pacs='sudo pacman -S'
    alias pacr='sudo pacman -R'
    alias pacq='pacman -Qe'
    alias pacu='sudo pacman -U'
    alias pacupd='sudo pacman -Syu'
end

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

if command -q flatpak
    alias fp='flatpak'
    alias fpi='flatpak install'
    alias fpr='flatpak remove'
end

if command -q yay
    alias ya='yay'
    alias ys='yay -S'
    alias yr='yay -R'
    alias yu='yay -U'
    alias yi='yay -S --noconfirm'
    alias yq='yay -Qe'
    alias yupd='yay -Syu --noconfirm'
end
