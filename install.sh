#!/bin/bash
# install.sh for GitHub codespaces
echo "cloning zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
echo "cloning zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
echo "cloning you-should-use-this"
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-you-should-use
echo "cloning powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
echo "make sure $HOME/.config/ exists"
mkdir -p "$HOME"/.config/
echo "symlink ripgrep config dir"
ln -sf --relative .config/ripgrep "$HOME"/.config/ripgrep
echo "symlink neovim config dir"
ln -sf --relative .config/nvim "$HOME"/.config/nvim
echo "symlink git config dir"
ln -sf --relative .config/git "$HOME"/.config/git
echo "symlink zshrc"
ln -sf --relative .zshrc "$HOME"/.zshrc
echo "symlink p10k.zsh"
ln -sf --relative .p10k.zsh "$HOME"/.p10k.zsh
echo "switch shell to zsh"
sudo chsh "$(id -un)" --shell "/usr/bin/zsh"
echo "download and install git delta"
wget https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_amd64.deb
sudo dpkg -i git-delta_0.18.2_amd64.deb
rm git-delta_0.18.2_amd64.deb


