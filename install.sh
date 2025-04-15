#!/bin/bash
# install.sh for GitHub codespaces
# Make sure .config dir exists
mkdir -p "$HOME"/.config/
# Symlink ripgrep config dir
ln -s --relative .config/ripgrep "$HOME"/.config/ripgrep
# Symlink neovim config dir
ln -s --relative .config/nvim "$HOME"/.config/nvim
