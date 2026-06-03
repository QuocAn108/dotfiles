#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 1. Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}==> Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    echo -e "${GREEN}==> Oh My Zsh installed successfully!${NC}"
fi

# 2. Install Powerlevel10k theme if not present
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo -e "${BLUE}==> Installing Powerlevel10k theme...${NC}"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
fi

# 3. Install custom plugins if not present
PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$PLUGINS_DIR"

if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
    echo -e "${BLUE}==> Installing zsh-autosuggestions...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
fi

if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
    echo -e "${BLUE}==> Installing zsh-syntax-highlighting...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
fi

if [ ! -d "$PLUGINS_DIR/zsh-completions" ]; then
    echo -e "${BLUE}==> Installing zsh-completions...${NC}"
    git clone https://github.com/zsh-users/zsh-completions "$PLUGINS_DIR/zsh-completions"
fi

echo -e "${GREEN}==> Oh My Zsh and plugins verification completed.${NC}"
