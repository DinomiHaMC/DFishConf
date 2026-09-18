#!/usr/bin/env bash

# DFishFetch — compact DFishConf description in a fastfetch-like style.
# Repository: https://github.com/DinomiHaMC/DFishConf

set -u

# Disable colors when stdout is not a terminal or NO_COLOR is set.
if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  RESET=$'\033[0m'
  BOLD=$'\033[1m'
  DIM=$'\033[2m'

  CYAN=$'\033[38;5;51m'
  BLUE=$'\033[38;5;39m'
  PURPLE=$'\033[38;5;141m'
  GREEN=$'\033[38;5;82m'
  YELLOW=$'\033[38;5;220m'
  WHITE=$'\033[38;5;255m'
else
  RESET=""
  BOLD=""
  DIM=""
  CYAN=""
  BLUE=""
  PURPLE=""
  GREEN=""
  YELLOW=""
  WHITE=""
fi

DISTRO=$(lsb_release -i -s)
REPO="DinomiHaMC/DFishConf"
URL="https://github.com/$REPO"

logo=(
  '________  ____________________  '
  '\______ \ \_   _____/\_   ___ \ '
  ' |    |  \ |    __)  /    \  \/ '
  ' |    `   \|     \   \     \____'
  '/_______  /\___  /    \______  /'
  '        \/     \/            \/ '
  'DinoMiHa    Fish       Config   '
)

info=(
  "${BOLD}${CYAN}DinomiHaMC${RESET}${WHITE}@${RESET}${BOLD}${BLUE}DFishConf${RESET}"
  "${DIM}────────────────────────────────────────${RESET}"
  "${PURPLE}Shell${RESET}      fish"
  "${PURPLE}Distro${RESET}     ${DISTRO}"
  "${PURPLE}CLI${RESET}        nvim · git · zoxide · lsd · btop"
  "${PURPLE}Extras${RESET}     lazygit · lazyssh · lazydocker · superfile"
  "${PURPLE}Repo${RESET}       ${CYAN}${URL}${RESET}"
  ""
)

# Remove ANSI escape sequences to calculate visible width.
visible_len() {
  local s="$1"
  s="${s//$'\033'\[[0-9;]*m/}"
  # Bash pattern replacement above isn't a full regex, so use sed for reliability.
  printf '%s' "$1" | sed -E $'s/\x1B\\[[0-9;]*[mK]//g' | awk '{ print length }'
}

max_logo=0
for line in "${logo[@]}"; do
  len=$(visible_len "$line")
  ((len > max_logo)) && max_logo=$len
done

rows=${#logo[@]}
((${#info[@]} > rows)) && rows=${#info[@]}

printf '\n'

for ((i = 0; i < rows; i++)); do
  left="${logo[i]:-}"
  right="${info[i]:-}"

  left_len=$(visible_len "$left")
  padding=$((max_logo - left_len + 4))

  if [[ -n "$left" ]]; then
    printf '%s%s%s' "$CYAN" "$left" "$RESET"
  else
    printf '%*s' "$max_logo" ''
  fi

  printf '%*s%s\n' "$padding" '' "$right"
done

printf '\n'
