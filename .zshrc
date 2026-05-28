# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# only for Mac
if [[ $OSTYPE == darwin* ]]; then
    # Set homebrew prefix its different between ARM and X86
    if [ -d "/opt/homebrew/bin" ]; then
        HOMEBREW_PREFIX="/opt/homebrew"
    else
        HOMEBREW_PREFIX="/usr/local"
    fi

    # Add homebrew bin paths
    export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin:$PATH"

    # Add whois bin path
    export PATH="${}/opt/whois/bin:$PATH"

    # Add homebrew fpath
    export FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"

    # brew coreutils, like sha256sum
    export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"

    # Add cargo bin path
    export PATH="$HOME/.cargo/bin/:$PATH"

    # pyenv setup
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(${HOMEBREW_PREFIX}/bin/pyenv init --path)"

    # Only autostart tmux if in iterm
    if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
            # tmux setup
            ZSH_TMUX_AUTOSTART="true"
            ZSH_TMUX_DEFAULT_SESSION_NAME="base"
    fi

    # Only set iterm2 specific config if we are running iterm2
    if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
            alias i2black="it2setcolor bg 000000"
            alias i2red="it2setcolor bg 700000"
            alias i2blue="it2setcolor bg 000050"
            alias i2purple="it2setcolor bg 300050"
    fi
fi
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set LANG
export LANG="en_US.UTF-8"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Which plugins would you like to load?
plugins=(git fzf virtualenv golang)

if [[ $OSTYPE == darwin* ]]; then
    plugins+=( brew pyenv tmux pyenv )
fi

source $ZSH/oh-my-zsh.sh

# Shared aliases, exports, and helpers — symlinked from dotfiles on both platforms
[[ -f ~/.zsh-common.zsh ]] && source ~/.zsh-common.zsh

# Mac-only: brew-installed zsh plugins
if [[ $OSTYPE == darwin* ]]; then
    source ${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ${HOMEBREW_PREFIX}/share/zsh-you-should-use/you-should-use.plugin.zsh
fi

# Mac-only: powerlevel10k is a git clone, not a package
alias p10k-update='git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
