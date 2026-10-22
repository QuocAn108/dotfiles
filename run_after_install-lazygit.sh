#!/bin/bash
set -e

# 1. Check if lazygit is already installed
if command -v lazygit >/dev/null 2>&1 || [ -x "$HOME/.local/bin/lazygit" ]; then
    exit 0
fi

echo -e "\033[0;34m==> lazygit is not installed. Bootstrapping lazygit to ~/.local/bin...\033[0m"

# Ensure ~/.local/bin exists
mkdir -p "$HOME/.local/bin"

ARCH=$(uname -m)
case "$ARCH" in
    x86_64)        LAZYGIT_ARCH="x86_64" ;;
    aarch64|arm64) LAZYGIT_ARCH="arm64" ;;
    armv6*)        LAZYGIT_ARCH="armv6" ;;
    i386|i686)     LAZYGIT_ARCH="32-bit" ;;
    *)             LAZYGIT_ARCH="x86_64" ;;
esac

# Resolve latest release version without GitHub API rate limit
LATEST_TAG=$(curl -sL -o /dev/null -w "%{url_effective}" https://github.com/jesseduffield/lazygit/releases/latest | sed 's|.*/tag/v*||')
if [ -z "$LATEST_TAG" ] || [ "$LATEST_TAG" = "latest" ]; then
    LATEST_TAG="0.66.2"
fi

TMP_DIR=$(mktemp -d)
TAR_FILE="$TMP_DIR/lazygit.tar.gz"
DOWNLOAD_URL="https://github.com/jesseduffield/lazygit/releases/download/v${LATEST_TAG}/lazygit_${LATEST_TAG}_linux_${LAZYGIT_ARCH}.tar.gz"

echo -e "\033[0;34m==> Downloading lazygit v${LATEST_TAG} (${LAZYGIT_ARCH})...\033[0m"
if curl -fsSL "$DOWNLOAD_URL" -o "$TAR_FILE"; then
    tar -xzf "$TAR_FILE" -C "$TMP_DIR" lazygit
    install -m 755 "$TMP_DIR/lazygit" "$HOME/.local/bin/lazygit"
    rm -rf "$TMP_DIR"
    echo -e "\033[0;32m==> lazygit v${LATEST_TAG} installed successfully into $HOME/.local/bin/lazygit!\033[0m"
else
    rm -rf "$TMP_DIR"
    echo -e "\033[1;33m==> Warning: Failed to download lazygit from GitHub. Please install manually.\033[0m"
fi
