status is-interactive; or return

alias gc='git clone'
alias ga='git add'
alias gal='git add .'
alias gcm='git commit -m'
alias gp='git push'
alias gin='git init'

if command -q nvim
    alias nv='kit nvim'
    alias nvf='nv ~/.config/fish/config.fish'
    alias nvn='nv ~/.config/niri/config.kdl'
    alias snv='kit sudo nvim'
end
