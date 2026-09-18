status is-interactive; or return

alias kit='TERM=xterm-kitty'
alias proxy='env HTTP_PROXY=http://127.0.0.1:10809 HTTPS_PROXY=http://127.0.0.1:10809 NO_PROXY=localhost,127.0.0.1'

if command -q lsd
    alias ls='lsd'
    alias sl='lsd'
end

alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

command -q btop; and alias mon='btop'
command -q fastfetch; and alias ff='fastfetch'
alias fff='ff'
alias f='ff'
command -q spf; and alias sf='spf'

if command -q bat
    alias bt='bat'
else if command -q batcat
    alias bt='batcat'
end

command -q lazyssh; and alias lssh='kit lazyssh'
command -q lazygit; and alias lg='kit lazygit'
command -q lazydocker; and alias ldoc='kit lazydocker'
