#!/bin/bash
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo "Dotfiles directory: $DOTFILES_DIR"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📦 Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Syntax Highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

link_file() {
    local src=$1
    local dest=$2

    mkdir -p "$(dirname "$dest")"
    rm -rf "$dest"

    ln -s "$src" "$dest"
}

APPS=("zsh" "tmux" "nvim")

for app in "${APPS[@]}"; do
    echo "Linking $app..."
    
    find "$DOTFILES_DIR/$app" -type f | while read -r src; do
        relative_path=${src#$DOTFILES_DIR/$app/}
        dest="$HOME/$relative_path"
        
        link_file "$src" "$dest"
    done
done
