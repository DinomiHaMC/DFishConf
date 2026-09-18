status is-interactive; or return

if command -q python
    alias py='python'
else if command -q python3
    alias py='python3'
end

if command -q pip
    alias pyi='pip install --break-system-packages'
else if command -q pip3
    alias pyi='pip3 install --break-system-packages'
end

alias pyir='pyi -r requirements.txt'
