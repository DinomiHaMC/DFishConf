function use
    if test (count $argv) -eq 0
        echo "usage: use <path|url>"
        return 1
    end

    set target $argv[1]

    # URL
    if string match -rq '^https?://' -- "$target"
        xdg-open "$target" >/dev/null 2>&1 &
        return
    end

    # Проверяем существование
    if not test -e "$target"
        echo "use: '$target' does not exist"
        return 1
    end

    # Директория → cd
    if test -d "$target"
        cd "$target"
        return
    end

    # Определяем расширение
    set ext (string lower (path extension "$target"))

    switch "$ext"

        # Текст / код → nvim
        case '.sh' '.bash' '.fish'
            nv "$target"

        case '.py' '.js' '.ts' '.jsx' '.tsx'
            nv "$target"

        case '.c' '.h' '.cpp' '.hpp' '.rs' '.go' '.java'
            nv "$target"

        case '.html' '.css' '.scss'
            nv "$target"

        case '.json' '.yaml' '.yml' '.toml' '.ini' '.conf' '.kdl'
            nv "$target"

        case '.md' '.txt'
            nv "$target"


        # Изображения
        case '.png' '.jpg' '.jpeg' '.webp' '.gif' '.svg'
            xdg-open "$target" >/dev/null 2>&1 &


        # PDF
        case '.pdf'
            xdg-open "$target" >/dev/null 2>&1 &


        # Видео
        case '.mp4' '.mkv' '.webm' '.avi' '.mov'
            xdg-open "$target" >/dev/null 2>&1 &


        # Аудио
        case '.mp3' '.flac' '.wav' '.ogg' '.m4a'
            xdg-open "$target" >/dev/null 2>&1 &


        # Архивы
        case '.zip' '.7z' '.rar' '.tar' '.gz' '.xz'
            ark "$target"


        # Всё неизвестное
        case '*'
            set mime (file --brief --mime-type "$target")

            if string match -q 'text/*' "$mime"
                nv "$target"
            else
                xdg-open "$target" >/dev/null 2>&1 &
            end
    end
end
