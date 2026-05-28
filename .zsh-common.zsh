# Shared zsh config — sourced from both the Mac .zshrc and the NixOS
# home-manager zsh module. Platform-specific stuff (homebrew, oh-my-zsh
# install, plugin paths) lives in each platform's top-level zshrc.

# Go paths (defensive — go may not be installed)
export GOPATH="$(go env GOPATH 2>/dev/null || echo $HOME/go)"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# less settings
export LESS="--chop-long-lines --HILITE-UNREAD --ignore-case \
  --incsearch --jump-target=4 --LONG-PROMPT --no-init \
  --quit-if-one-screen --RAW-CONTROL-CHARS --use-color --window=-4"

# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
function rg { command rg --json --context 2 "$@" | delta --tabs=1; }

# Editor
if (( $+commands[nvim] )); then
  export EDITOR=nvim
fi

# git cu base dir
export GIT_CU_DIR=~/git

# Aliases
alias ll='ls -lhF --color'
alias llt='ls -latrFh --color'
alias lr='ls -latrFh --color'
alias la='ls -ahF --color'
alias lla='ls -lahF --color'
alias l='ls -CF --color'
alias unvim='uv run nvim'

# Git worktree helper
function gwtab { gwta -b "$1" "$1"; }

# Zellij
alias zj='zellij attach --create'
function zjp {
  local sel
  sel=$(zellij list-sessions -s 2>/dev/null | fzf --print-query | tail -n1) || return
  [[ -n "$sel" ]] && zellij attach --create "$sel"
}
function zjh { zellij attach --create "$(basename "$PWD")"; }

# Work/BM overlays
[[ -f $HOME/.work.zsh ]] && source $HOME/.work.zsh
[[ -f $HOME/.bm.zsh   ]] && source $HOME/.bm.zsh
