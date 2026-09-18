function ffinder
    set -l query (string join " " $argv)
    nohup firefox --new-window "https://www.google.com/search?q=$query" >/dev/null 2>&1 &
end
