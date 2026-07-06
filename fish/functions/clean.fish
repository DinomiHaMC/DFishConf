function clean
    if command -q pacman
        set orphans (pacman -Qdtq)

        if test (count $orphans) -gt 0
            echo "Removing orphan packages..."
            sudo pacman -Rns --noconfirm $orphans
        else
            echo "No orphan packages"
        end

        if command -q yay
            echo "Cleaning AUR dependencies..."
            yay -Yc --noconfirm
        end

        echo "Cleaning package cache..."
        sudo rm -rf /var/cache/pacman/pkg/download-*/

        if test -d ~/.cache/yay
            echo "Removing yay cache..."
            rm -rf ~/.cache/yay
        end
    else if command -q apt
        echo "Removing unused apt packages..."
        sudo apt autoremove -y

        echo "Cleaning apt cache..."
        sudo apt autoclean -y
        sudo apt clean
    else
        echo "No supported package manager found"
    end

    if command -q journalctl
        echo "Cleaning logs..."
        sudo journalctl --vacuum-time=7d
    end

    echo "Cleanup done"
end
