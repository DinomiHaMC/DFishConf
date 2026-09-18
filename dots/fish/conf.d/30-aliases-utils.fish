status is-interactive; or return

alias nano='nano'
alias na='nano'
alias sna='sudo nano'
alias snano='sna'
alias sy='sudo y'

alias home='cd ~'
alias dc='cd'
alias hom='home'
alias hm='home'
alias rm='rm -rf'
alias mk='mkdir -p'
alias md='mkdir -p'
alias link='ln -s'
alias kill='pkill -9 -f'
alias shn='shutdown now'
alias rbt='reboot'
alias weather='curl wttr.in/moscow'
alias Telegram='proxy Telegram'

command -q fastfetch; and alias clear='clear && fastfetch'
alias DFishC-fetch='bash ~/DFishC/DFetch.sh'
alias DFishC-update='cd ~/DFishC && git pull && cd -'

if test -x "$HOME/openclaude/bin/openclaude"
    alias occ="$HOME/openclaude/bin/openclaude"
end

if test -f "$HOME/zap/service.sh"
    alias fix="$HOME/zap/service.sh run -s 'general (ALT).bat'"
end
