#!/usr/bin/env bash

set -u

REPO_URL="https://github.com/DinomiHaMC/DFishConf.git"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_REPO="$SCRIPT_DIR"
DISTRO_FAMILY=""

ask_yes_no() {
  local question="$1"
  local answer

  read -r -p "$question (yes/no): " answer
  answer="${answer,,}"
  [[ "$answer" != "no" && "$answer" != "n" ]]
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

detect_distro_family() {
  if [[ -r /etc/os-release ]]; then
    # shellcheck disable=SC1091
    source /etc/os-release
    local ids=" ${ID:-} ${ID_LIKE:-} "

    if [[ "${ID:-}" == "nixos" ]]; then
      DISTRO_FAMILY="nixos"
      return
    fi

    if [[ "$ids" == *"arch"* ]]; then
      DISTRO_FAMILY="arch"
      return
    fi

    if [[ "$ids" == *"debian"* || "$ids" == *"ubuntu"* ]]; then
      DISTRO_FAMILY="debian"
      return
    fi
  fi

  if have_cmd nixos-rebuild; then
    DISTRO_FAMILY="nixos"
  elif have_cmd pacman; then
    DISTRO_FAMILY="arch"
  elif have_cmd apt; then
    DISTRO_FAMILY="debian"
  else
    echo "Не удалось определить дистрибутив. Поддерживаются NixOS, Debian/Ubuntu-based и Arch-based."
    DISTRO_FAMILY="unknown"
  fi
}

install_arch_yay() {
  if [[ "$DISTRO_FAMILY" != "arch" ]]; then
    echo "yay устанавливается только на Arch/Arch-based, пропускаю"
    return
  fi

  if have_cmd yay; then
    echo "yay уже установлен"
    return
  fi

  sudo pacman -S --noconfirm --needed git base-devel

  if [[ -d "$HOME/yay/.git" ]]; then
    git -C "$HOME/yay" pull --ff-only
  else
    rm -rf "$HOME/yay"
    git clone https://aur.archlinux.org/yay.git "$HOME/yay"
  fi

  (cd "$HOME/yay" && makepkg -si --noconfirm)
}

install_arch_packages() {
  local pacman_packages=(
    git
    base-devel
    lsd
    btop
    fastfetch
    lazygit
    bat
    neovim
    ntfs-3g
    openssh
    docker
    python
    python-pip
    zoxide
    fish
  )

  local yay_packages=(
    lazyssh
    lazydocker
    superfile
  )

  for package in "${pacman_packages[@]}"; do
    sudo pacman -S --noconfirm --needed "$package" || echo "Не удалось установить $package через pacman"
  done

  install_arch_yay

  for package in "${yay_packages[@]}"; do
    yay -S --noconfirm --needed "$package" || echo "Не удалось установить $package через yay"
  done
}

install_debian_packages() {
  local apt_packages=(
    ca-certificates
    curl
    git
    lsd
    btop
    fastfetch
    lazygit
    bat
    neovim
    ntfs-3g
    openssh-client
    openssh-server
    docker.io
    python3
    python3-pip
    python-is-python3
    zoxide
    fish
  )

  sudo apt update

  for package in "${apt_packages[@]}"; do
    sudo apt install -y "$package" || echo "Не удалось установить $package через apt"
  done

  echo "lazyssh, lazydocker и superfile могут отсутствовать в apt-репозиториях. Установи их вручную, если они нужны."
}

install_nixos_packages() {
  if ! have_cmd nix; then
    echo "nix не найден, установку пакетов пропускаю"
    return
  fi

  if ! nix registry list | grep -q '^global flake:nixpkgs'; then
    echo "nixpkgs не найден в registry. Если установка не сработает, настрой flakes/nixpkgs."
  fi

  local nix_packages=(
    nixpkgs#git
    nixpkgs#fish
    nixpkgs#neovim
    nixpkgs#fastfetch
    nixpkgs#btop
    nixpkgs#bat
    nixpkgs#lsd
    nixpkgs#lazygit
    nixpkgs#openssh
    nixpkgs#docker
    nixpkgs#python3
    nixpkgs#python312Packages.pip
    nixpkgs#ntfs3g
    nixpkgs#zoxide
  )

  for package in "${nix_packages[@]}"; do
    nix profile install "$package" || echo "Не удалось установить $package через nix profile"
  done

  echo
  echo "NixOS: Docker и fish лучше включить декларативно в /etc/nixos/configuration.nix:"
  echo
  echo "  programs.fish.enable = true;"
  echo "  virtualisation.docker.enable = true;"
  echo
  echo "После изменения configuration.nix выполни:"
  echo "  sudo nixos-rebuild switch"
}

install_packages() {
  case "$DISTRO_FAMILY" in
  arch)
    install_arch_packages
    ;;
  debian)
    install_debian_packages
    ;;
  nixos)
    install_nixos_packages
    ;;
  *)
    echo "Тип системы не определён, установку пакетов пропускаю"
    ;;
  esac
}

install_zapret() {
  if [[ -d "$HOME/zap/.git" ]]; then
    git -C "$HOME/zap" pull --ff-only
  else
    rm -rf "$HOME/zap"
    git clone https://github.com/Sergeydigl3/zapret-discord-youtube-linux.git "$HOME/zap"
  fi

  if [[ "$DISTRO_FAMILY" == "unknown" ]]; then
    echo "Тип системы не определён, зависимости zapret не устанавливаю"
  elif [[ "$DISTRO_FAMILY" == "nixos" ]]; then
    echo "NixOS: зависимости zapret лучше добавить в configuration.nix."
    echo "Попробую запустить download-deps, но на NixOS это может не сработать."
    "$HOME/zap/service.sh" download-deps --default || echo "zapret download-deps не сработал на NixOS"
  else
    "$HOME/zap/service.sh" download-deps --default
  fi
}

install_lazyvim() {
  rm -rf "$HOME/.config/nvim"
  git clone https://github.com/LazyVim/starter "$HOME/.config/nvim"
  rm -rf "$HOME/.config/nvim/.git"
}

ensure_config_repo() {
  if [[ -d "$CONFIG_REPO/fish" ]]; then
    return
  fi

  if [[ -d "$HOME/DFishC/fish" ]]; then
    CONFIG_REPO="$HOME/DFishC"
    return
  fi

  git clone "$REPO_URL" "$HOME/DFishC"
  CONFIG_REPO="$HOME/DFishC"
}

install_configs() {
  ensure_config_repo

  mkdir -p "$HOME/.config/fish"
  rm -rf "$HOME/.config/fish/conf.d" \
    "$HOME/.config/fish/completions" \
    "$HOME/.config/fish/functions"

  for item in config.fish fish_variables fish_plugins conf.d completions functions; do
    if [[ -e "$CONFIG_REPO/fish/$item" ]]; then
      rm -rf "$HOME/.config/fish/$item"
      cp -a "$CONFIG_REPO/fish/$item" "$HOME/.config/fish/"
    fi
  done

  if [[ -d "$CONFIG_REPO/fastfetch" ]]; then
    rm -rf "$HOME/.config/fastfetch"
    cp -a "$CONFIG_REPO/fastfetch" "$HOME/.config/"
  fi
}

install_fish_launcher() {
  local chsh_mode="${1:-ask}"
  local fish_path
  fish_path="$(command -v fish || true)"

  if [[ -z "$fish_path" ]]; then
    echo "fish не найден, пропускаю настройку shell"
    return
  fi

  if [[ "$DISTRO_FAMILY" == "nixos" ]]; then
    echo "NixOS: рекомендуется включить fish декларативно:"
    echo
    echo "  programs.fish.enable = true;"
    echo
    echo "и для пользователя:"
    echo
    echo "  users.users.$USER.shell = pkgs.fish;"
    echo
    echo "После этого:"
    echo "  sudo nixos-rebuild switch"
    return
  fi

  if ! grep -Fqx "$fish_path" /etc/shells 2>/dev/null; then
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  fi

  if [[ "$chsh_mode" == "yes" ]] || { [[ "$chsh_mode" == "ask" ]] && ask_yes_no "Сделать fish shell по умолчанию через chsh?"; }; then
    chsh -s "$fish_path" || echo "chsh не сработал. Добавлю запуск fish в ~/.bashrc."
  fi

  local marker="# DFishC fish launcher"
  if ! grep -Fq "$marker" "$HOME/.bashrc" 2>/dev/null; then
    {
      echo ""
      echo "$marker"
      echo 'if command -v fish >/dev/null 2>&1 && [ -z "$FISH_VERSION" ] && [ -t 1 ]; then'
      echo '  exec fish'
      echo 'fi'
    } >>"$HOME/.bashrc"
  fi
}

install_dsort() {
  cp ~/DFishC/DSort.sh ~
}

show_nixos_config_hint() {
  cat <<EOF

Для полноценной настройки NixOS лучше добавить в /etc/nixos/configuration.nix:

environment.systemPackages = with pkgs; [
  git
  fish
  neovim
  fastfetch
  btop
  bat
  lsd
  lazygit
  openssh
  docker
  python3
  python312Packages.pip
  ntfs3g
  zoxide
];

programs.fish.enable = true;
virtualisation.docker.enable = true;

users.users.$USER = {
  extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" ];
  shell = pkgs.fish;
};

Потом выполнить:

  sudo nixos-rebuild switch

EOF
}

run_auto_install() {
  install_packages
  install_zapret
  install_lazyvim
  install_configs
  install_fish_launcher no

  if [[ "$DISTRO_FAMILY" == "nixos" ]]; then
    show_nixos_config_hint
  fi
}

run_manual_install() {
  if [[ "$DISTRO_FAMILY" == "arch" ]] && ask_yes_no "Установить yay?"; then
    install_arch_yay
  fi

  if ask_yes_no "Установить полезные программы?"; then
    install_packages
  fi

  if ask_yes_no "Установить запрет?"; then
    install_zapret
  fi

  if ask_yes_no "Установить LazyVim?"; then
    install_lazyvim
  fi

  if ask_yes_no "Установить конфиги fish/fastfetch?"; then
    install_configs
  fi

  if ask_yes_no "Настроить запуск fish вместо bash?"; then
    install_fish_launcher ask
  fi

  if ask_yes_no "Установить Сортировщик (DSort.sh)?"; then
    install_dsort
  fi

  if [[ "$DISTRO_FAMILY" == "nixos" ]] && ask_yes_no "Показать пример configuration.nix для NixOS?"; then
    show_nixos_config_hint
  fi
}

detect_distro_family
echo "Определён тип системы: $DISTRO_FAMILY"

if [[ "$DISTRO_FAMILY" == "unknown" ]] && ! ask_yes_no "Продолжить без distro-specific команд?"; then
  echo "Остановка установки."
  exit 0
fi

if ask_yes_no "Включить автоустановку?"; then
  run_auto_install
else
  run_manual_install
fi

echo "Готово. После установки shell лучше перелогиниться или перезагрузиться."
