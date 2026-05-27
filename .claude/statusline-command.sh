#!/bin/sh
# Claude Code status line
# Single left-aligned line: dir  branch  model  ctx%

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten home directory to ~
home="$HOME"
short_dir="${cwd/#$home/\~}"

# ── Directory (bold) ─────────────────────────────────────────────────────────

line="\033[1m${short_dir}\033[0m"

# ── Git branch (skip optional locks so we never block the prompt) ─────────────

if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git -C "$cwd" -c core.hooksPath=/dev/null symbolic-ref --short HEAD 2>/dev/null \
             || git -C "$cwd" -c core.hooksPath=/dev/null rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        if ! git -C "$cwd" diff --quiet --cached 2>/dev/null || \
           ! git -C "$cwd" diff --quiet 2>/dev/null; then
            line="${line}  \033[33m${branch}*\033[0m"
        else
            line="${line}  \033[32m${branch}\033[0m"
        fi
    fi
fi

# ── Model (cyan) ─────────────────────────────────────────────────────────────

if [ -n "$model" ]; then
    line="${line}  \033[36m${model}\033[0m"
fi

# ── Context window (white / yellow / red) ────────────────────────────────────

if [ -n "$used_pct" ]; then
    used_int=$(printf '%.0f' "$used_pct")
    if [ "$used_int" -ge 80 ]; then
        line="${line}  \033[31mctx:${used_int}%\033[0m"
    elif [ "$used_int" -ge 50 ]; then
        line="${line}  \033[33mctx:${used_int}%\033[0m"
    else
        line="${line}  ctx:${used_int}%"
    fi
fi

# ── Output ───────────────────────────────────────────────────────────────────

printf "%b" "$line"
