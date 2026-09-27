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

# direnv — hook into zsh so per-directory envs (e.g. the nix-config flake
# devShell providing nixd) load on cd. Guarded so it's a no-op where direnv
# isn't installed; direnv's hook output is idempotent, so re-running on hosts
# already hooked by home-manager is harmless.
#
# DIRENV_LOG_FORMAT="" silences direnv's "loading"/"export +AR +AS …" chatter.
# A Nix devShell exports a huge var set, so that log is noisy on every cd, and
# any console output during zsh init trips Powerlevel10k's instant-prompt guard.
if (( $+commands[direnv] )); then
  export DIRENV_LOG_FORMAT=""
  eval "$(direnv hook zsh)"
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

# Remove a host's key(s) from known_hosts (handy after a host is reprovisioned)
function sshrm {
  if [ $# -eq 0 ]; then
    echo "usage: sshrm <hostname-or-ip> [more hosts...]" >&2
    return 1
  fi
  for host in "$@"; do
    ssh-keygen -R "$host"
  done
}

# Work/BM overlays
[[ -f $HOME/.work.zsh ]] && source $HOME/.work.zsh
[[ -f $HOME/.bm.zsh   ]] && source $HOME/.bm.zsh
