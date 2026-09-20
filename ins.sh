#!/usr/bin/env bash

set -Eeuo pipefail

on_error() {
  local exit_code=$?
  echo "Ошибка: команда завершилась с кодом $exit_code (строка ${BASH_LINENO[0]:-неизвестна}): ${BASH_COMMAND:-неизвестная команда}" >&2
  exit "$exit_code"
}
trap on_error ERR

REPO_URL="https://github.com/DinomiHaMC/DFishConf.git"
ZAPRET_REPO_URL="https://github.com/Sergeydigl3/zapret-discord-youtube-linux.git"
ZAPRET_COMMIT="69db771b527ba11ca71efe28728a7f9491eec352"
FASTCOMMANDER_REPO_URL="https://github.com/DinomiHaMC/FastCommanderTUI.git"
FASTCOMMANDER_COMMIT="89d42fc7ac6dffd3db9689c48e79004a8e032e1b"
YAY_REPO_URL="https://aur.archlinux.org/yay.git"
YAY_COMMIT="cb43f84828ab4f9700f7c6f9c6d7a923d4cfaff0"
LAZYVIM_REPO_URL="https://github.com/LazyVim/starter.git"
LAZYVIM_COMMIT="803bc181d7c0d6d5eeba9274d9be49b287294d99"

SCRIPT_DIR=""
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
  SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
fi
CONFIG_REPO="$SCRIPT_DIR"
DISTRO_FAMILY=""
CURRENT_USER="${USER:-$(id -un)}"
WARNING_COUNT=0

warn() {
  echo "Предупреждение: $*" >&2
  ((WARNING_COUNT += 1))
}

die() {
  echo "Ошибка: $*" >&2
  exit 1
}

ask_yes_no() {
  local question="$1"
  local answer

  while true; do
    if [[ -t 0 ]]; then
      if ! IFS= read -r -p "$question [y/N]: " answer; then
        warn "не удалось прочитать ответ; выбрано 'нет'"
        return 1
      fi
    elif can_prompt; then
      if ! IFS= read -r -p "$question [y/N]: " answer </dev/tty; then
        echo >&2
        warn "не удалось прочитать ответ из терминала; выбрано 'нет'"
        return 1
      fi
    else
      warn "интерактивный терминал недоступен; для '$question' выбрано 'нет'"
      return 1
    fi

    answer="${answer,,}"
    case "$answer" in
    y | yes | д | да)
      return 0
      ;;
    n | no | н | нет | "")
      return 1
      ;;
    *)
      echo "Введите yes/y (да) или no/n (нет)." >&2
      ;;
    esac
  done
}

can_prompt() {
  [[ -t 0 ]] || { : </dev/tty; } 2>/dev/null
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

backup_existing() {
  local target="$1"
  local category="${2:-files}"
  local backup_root="$HOME/.local/state/dfishc/backups/$(date +%Y%m%d-%H%M%S)/$category"
  local destination="$backup_root/$(basename -- "$target")"

  [[ -e "$target" || -L "$target" ]] || return 0
  mkdir -p -- "$backup_root"
  while [[ -e "$destination" || -L "$destination" ]]; do
    destination="${destination}.bak"
  done
  mv -- "$target" "$destination"
  echo "Резервная копия: $destination"
}

checkout_pinned_repo() {
  local url="$1"
  local commit="$2"
  local target="$3"
  local temp_root=""
  local actual_commit=""
  local reuse_existing=false

  if [[ -d "$target/.git" ]] && [[ -z "$(git -C "$target" status --porcelain 2>/dev/null)" ]]; then
    reuse_existing=true
  fi

  if [[ "$reuse_existing" == true ]]; then
    git -C "$target" remote set-url origin "$url" || return 1
    git -C "$target" fetch --depth 1 origin "$commit" || return 1
    git -C "$target" checkout --detach "$commit" || return 1
  else
    temp_root="$(mktemp -d "${TMPDIR:-/tmp}/dfishc-source.XXXXXX")" || return 1
    if ! git -C "$temp_root" init -q repo ||
      ! git -C "$temp_root/repo" remote add origin "$url" ||
      ! git -C "$temp_root/repo" fetch --depth 1 origin "$commit" ||
      ! git -C "$temp_root/repo" checkout --detach "$commit"; then
      rm -rf -- "$temp_root"
      return 1
    fi
    if ! actual_commit="$(git -C "$temp_root/repo" rev-parse HEAD)"; then
      rm -rf -- "$temp_root"
      return 1
    fi
    if [[ "$actual_commit" != "$commit" ]]; then
      rm -rf -- "$temp_root"
      die "загруженная ревизия не совпадает с закреплённым commit $commit"
    fi
    backup_existing "$target" sources || return 1
    mkdir -p -- "$(dirname -- "$target")" || return 1
    mv -- "$temp_root/repo" "$target"
    rmdir -- "$temp_root"
  fi

  actual_commit="$(git -C "$target" rev-parse HEAD)" || return 1
  if [[ "$actual_commit" != "$commit" ]]; then
    die "ревизия $target не совпадает с закреплённым commit $commit"
  fi
  echo "Проверена ревизия $(basename -- "$target"): $commit"
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

  local yay_source="$HOME/.cache/dfishc/sources/yay"
  checkout_pinned_repo "$YAY_REPO_URL" "$YAY_COMMIT" "$yay_source"
  (cd "$yay_source" && makepkg -si --noconfirm)
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
    cargo
    python
    python-pip
    zoxide
    fish
    pyenv
    starship
  )

  local yay_packages=(
    lazyssh
    lazydocker
    superfile
  )

  for package in "${pacman_packages[@]}"; do
    if ! sudo pacman -S --noconfirm --needed "$package"; then
      warn "не удалось установить $package через pacman"
    fi
  done

  install_arch_yay

  for package in "${yay_packages[@]}"; do
    if ! yay -S --noconfirm --needed "$package"; then
      warn "не удалось установить $package через yay"
    fi
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
    cargo
    python3
    python3-pip
    python-is-python3
    zoxide
    fish
    pyenv
    starship
  )

  sudo apt update

  for package in "${apt_packages[@]}"; do
    if ! sudo apt install -y "$package"; then
      warn "не удалось установить $package через apt"
    fi
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
    nixpkgs#cargo
    nixpkgs#python3
    nixpkgs#python312Packages.pip
    nixpkgs#ntfs3g
    nixpkgs#zoxide
    nixpkgs#pyenv
    nixpkgs#starship
  )

  for package in "${nix_packages[@]}"; do
    if ! nix profile install "$package"; then
      warn "не удалось установить $package через nix profile"
    fi
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
  checkout_pinned_repo "$ZAPRET_REPO_URL" "$ZAPRET_COMMIT" "$HOME/zap"
  [[ -f "$HOME/zap/service.sh" ]] || die "в закреплённой версии zapret отсутствует service.sh"

  if [[ "$DISTRO_FAMILY" == "unknown" ]]; then
    echo "Тип системы не определён, зависимости zapret не устанавливаю"
  elif [[ "$DISTRO_FAMILY" == "nixos" ]]; then
    echo "NixOS: зависимости zapret лучше добавить в configuration.nix."
    echo "Попробую запустить download-deps, но на NixOS это может не сработать."
    if ! bash "$HOME/zap/service.sh" download-deps --default; then
      warn "zapret download-deps не сработал на NixOS"
    fi
  else
    bash "$HOME/zap/service.sh" download-deps --default
  fi
}

install_lazyvim() {
  local temp_root
  temp_root="$(mktemp -d "${TMPDIR:-/tmp}/dfishc-lazyvim.XXXXXX")"
  if ! checkout_pinned_repo "$LAZYVIM_REPO_URL" "$LAZYVIM_COMMIT" "$temp_root/nvim"; then
    rm -rf -- "$temp_root"
    return 1
  fi
  rm -rf -- "$temp_root/nvim/.git"
  mkdir -p -- "$HOME/.config"
  backup_existing "$HOME/.config/nvim" config
  mv -- "$temp_root/nvim" "$HOME/.config/nvim"
  rmdir -- "$temp_root"
}

install_fastcommander_tui() {
  local project_dir="$HOME/FastCommanderTUI"

  if ! have_cmd cargo; then
    echo "cargo не найден, FastCommanderTUI установить невозможно"
    return
  fi

  checkout_pinned_repo "$FASTCOMMANDER_REPO_URL" "$FASTCOMMANDER_COMMIT" "$project_dir"

  (cd "$project_dir" && cargo install --path .)
}

ensure_config_repo() {
  if [[ -n "$CONFIG_REPO" && -d "$CONFIG_REPO/dots" ]]; then
    return
  fi

  if [[ -d "$HOME/DFishC/dots" ]]; then
    CONFIG_REPO="$HOME/DFishC"
    return
  fi

  if [[ -e "$HOME/DFishC" || -L "$HOME/DFishC" ]]; then
    die "$HOME/DFishC уже существует, но не содержит dots; перемести или исправь этот каталог"
  fi

  local temp_root
  temp_root="$(mktemp -d "${TMPDIR:-/tmp}/dfishc-config.XXXXXX")"
  if ! git clone --depth 1 "$REPO_URL" "$temp_root/DFishC"; then
    rm -rf -- "$temp_root"
    return 1
  fi
  [[ -d "$temp_root/DFishC/dots" ]] || die "загруженный репозиторий не содержит dots"
  mv -- "$temp_root/DFishC" "$HOME/DFishC"
  rmdir -- "$temp_root"
  CONFIG_REPO="$HOME/DFishC"
}

install_configs() {
  ensure_config_repo
  local dots_dir="$CONFIG_REPO/dots"
  local stage_dir source target

  if [[ ! -d "$dots_dir" ]]; then
    die "каталог dots не найден: $dots_dir"
  fi

  mkdir -p "$HOME/.config"
  stage_dir="$(mktemp -d "$HOME/.config/.dfishc-stage.XXXXXX")"
  while IFS= read -r -d '' source; do
    cp -a -- "$source" "$stage_dir/$(basename -- "$source")"
  done < <(find "$dots_dir" -mindepth 1 -maxdepth 1 -print0)

  while IFS= read -r -d '' source; do
    target="$HOME/.config/$(basename -- "$source")"
    backup_existing "$target" config
    mv -- "$source" "$target"
  done < <(find "$stage_dir" -mindepth 1 -maxdepth 1 -print0)
  rmdir -- "$stage_dir"
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
    echo "  users.users.$CURRENT_USER.shell = pkgs.fish;"
    echo
    echo "После этого:"
    echo "  sudo nixos-rebuild switch"
    return
  fi

  if ! grep -Fqx "$fish_path" /etc/shells 2>/dev/null; then
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  fi

  if [[ "$chsh_mode" == "yes" ]] || { [[ "$chsh_mode" == "ask" ]] && ask_yes_no "Сделать fish shell по умолчанию через chsh?"; }; then
    if chsh -s "$fish_path"; then
      echo "fish назначен login shell; запуск через ~/.bashrc не требуется."
      return
    fi
    warn "chsh не сработал; будет добавлен запуск fish в ~/.bashrc"
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
  ensure_config_repo
  local source="$CONFIG_REPO/DSort.sh"
  local staged="$HOME/.DSort.sh.dfishc-new.$$"
  [[ -f "$source" ]] || die "файл сортировщика не найден: $source"
  cp -a -- "$source" "$staged"
  backup_existing "$HOME/DSort.sh" scripts
  mv -- "$staged" "$HOME/DSort.sh"
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
  cargo
  python3
  python312Packages.pip
  ntfs3g
  zoxide
  pyenv
  starship
];

programs.fish.enable = true;
virtualisation.docker.enable = true;

users.users.$CURRENT_USER = {
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
  install_fastcommander_tui
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

  if ask_yes_no "Скачать и установить FastCommanderTUI?"; then
    install_fastcommander_tui
  fi

  if ask_yes_no "Установить все конфиги из dots в ~/.config?"; then
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

can_prompt || die "интерактивный терминал недоступен; запусти установщик из терминала"

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

if ((WARNING_COUNT > 0)); then
  echo "Установка завершена с предупреждениями: $WARNING_COUNT. Проверь сообщения выше."
else
  echo "Установка завершена успешно."
fi
echo "После изменения shell лучше перелогиниться или перезагрузиться."
