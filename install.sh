# /usr/bin/env bash

declare -A TOOLS

TOOLS["fish"]="$HOME/.config/fish"
TOOLS["neovim"]="$HOME/.config/nvim"
TOOLS["wezterm"]="$HOME/.config/wezterm"
TOOLS["git"]="$HOME/.gitconfig"


repo_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

for tool in "${!TOOLS[@]}"; do
    target="${TOOLS[$tool]}"
    source="$repo_dir/$tool"

    if [ ! -d "$source" ]; then
        echo "skipping '$tool'..."
        continue
    fi

    if [ -e "$target" ]; then
        if [ -L "$target" ]; then
            echo "Aviso: '$target' já existe"
            continue
        fi

        echo "making backup for '$tool'"
        mv "$target" "$target.bkp"
    fi

    echo "creating symbolic link for '$tool'"
    mkdir -p "$(dirname "$target")"
    ln -sv "$source" "$target"
done

echo "test bash via fish '$repo_dir'"
