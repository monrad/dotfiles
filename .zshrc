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

    # Set homebrew download concurrency to auto
    export HOMEBREW_DOWNLOAD_CONCURRENCY=auto
 
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

# Add Go exports
export GOPATH=`go env GOPATH`
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# Add .local bin path
export PATH="$HOME/.local/bin:$PATH"


# Setup less settings
export LESS="\
--chop-long-lines \
--HILITE-UNREAD \
--ignore-case \
--incsearch \
--jump-target=4 \
--LONG-PROMPT \
--no-init \
--quit-if-one-screen \
--RAW-CONTROL-CHARS \
--use-color \
--window=-4"

# Setup ripgrep
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/ripgreprc
function rg { command rg --json --context 2 $@ | delta --tabs=1; }

# Add work stuff if this is here
if [[ -f $HOME/.work.zsh ]]; then
    source $HOME/.work.zsh
fi
# Add BM stuff is this is here
if [[ -f $HOME/.bm.zsh ]]; then
    source $HOME/.bm.zsh
fi
# Set editor to Neovim if binary is there
if (($+commands[nvim])); then
    export EDITOR=nvim
fi

# Export dir for git cu to use as basedir
export GIT_CU_DIR=~/git

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
plugins=(git fzf virtualenv golang)

if [[ $OSTYPE == darwin* ]]; then
    plugins+=( brew pyenv tmux pyenv )
fi

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

# run neovim with uv run
alias unvim='uv run nvim'

# git worktree add function
function gwtab {
	gwta -b $1 $1
}

if [[ $OSTYPE == darwin* ]]; then
    # Enable homebrew version of zsh autosuggestions
    source ${HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # Enable homebrew version of zsh syntax highlightning
    source ${HOMEBREW_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    # Enable homebrew version of zsh you should use
    source ${HOMEBREW_PREFIX}/share/zsh-you-should-use/you-should-use.plugin.zsh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
