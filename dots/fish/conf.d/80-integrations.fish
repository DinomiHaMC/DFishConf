status is-interactive; or return

command -q zoxide; and zoxide init fish | source

if command -q pyenv
    pyenv init - fish | source
end

if command -q starship
    starship init fish | source
end
