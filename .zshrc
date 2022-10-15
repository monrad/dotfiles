# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Add homebrew sbin path
export PATH="/usr/local/sbin:$PATH"

# Add Go bin path
export PATH="$HOME/go/bin:$PATH"

# Add .local bin path (for Poetry)
export PATH="$HOME/.local/bin:$PATH"

# Add work stuff if this is here
if [[ -f $HOME/.work.zsh ]]; then
    source $HOME/.work.zsh
fi
# Add BM stuff is this is here
if [[ -f $HOME/.bm.zsh ]]; then
    source $HOME/.bm.zsh
fi
# Set editor to Neovim if biniary is there
if [[ -f /usr/local/bin/nvim ]]; then
    export EDITOR=nvim
fi

# brew coreutils, like sha256sum
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# Export dir for git cu to use as basedir
export GIT_CU_DIR=~/git

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# tmux setup
ZSH_TMUX_AUTOSTART="false"
ZSH_TMUX_DEFAULT_SESSION_NAME="base"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git brew fzf pyenv macos doctl tmux)

source $ZSH/oh-my-zsh.sh

# User configuration

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ll='ls -lhF --color'
alias llt='ls -latrFh --color'
alias lr='ls -latrFh --color'
alias la='ls -ahF --color'
alias lla='ls -lahF --color'
alias l='ls -CF --color'

# alias to update Powerlevel10K
alias p10k-update='git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull'

# Only set kitty specific config if we are running kitty
if [ "$TERM" = "xterm-kitty" ]; then
        #Aliases
        alias ssh="kitty +kitten ssh" #short alias for kitty ssh
        #Bindkeys
        bindkey "\e[1;3D" backward-word # ⌥←
        bindkey "\e[1;3C" forward-word # ⌥→
fi

# Enable homebrew version of zsh autosuggestions
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# Enable homebrew version of zsh syntax highlightning
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
