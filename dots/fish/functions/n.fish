function n
    if test (count $argv) -eq 0
        nautilus . >/dev/null 2>&1 &
    else
        nautilus $argv >/dev/null 2>&1 &
    end
    disown
end
