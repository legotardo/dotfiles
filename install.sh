#!/bin/bash
DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo "Dotfiles directory: $DOTFILES_DIR"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
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

    if [ -f "$dest" ] || [ -L "$dest" ]; then
        rm "$dest"
    fi

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

if ! command -v lazygit &> /dev/null; then
    echo "Instalando lazygit (binário)..."

    LAZYGIT_VERSION="0.61.1"

    curl -Lo lazygit.tar.gz \
        https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_linux_x86_64.tar.gz 

    tar xf lazygit.tar.gz lazygit

    mkdir -p ~/.local/bin

    mv lazygit ~/.local/bin/
    chmod +x ~/.local/bin/lazygit
fi
