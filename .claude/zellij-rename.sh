#!/usr/bin/env bash
# Mirror the Claude session /rename title into the zellij session name.
# Wired to SessionStart / UserPromptSubmit / Stop hooks. Reads the hook JSON
# from stdin, looks up the session's title (set via /rename) in
# ~/.claude/sessions/<pid>.json, and renames the current zellij session to match.
#
# Limitation: no hook fires on /rename itself, so the name syncs on the next
# turn after renaming, not the instant you type /rename.
set -uo pipefail

# Only act when running inside a zellij session.
[ -n "${ZELLIJ_SESSION_NAME:-}" ] || exit 0

# Read the hook payload, but never block: Claude Code's hook invocation does
# not reliably close stdin, so a bare `cat` would hang the turn. Cap the read.
input=$(timeout 2 cat)
sid=$(printf '%s' "$input" | jq -r '.session_id // empty')
[ -n "$sid" ] || exit 0

# 1. Latest persisted title from the transcript. The built-in /rename command
#    (and any SDK renameSession call) appends a {"customTitle": ...} line here.
tpath=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
name=$(jq -r 'select(.customTitle) | .customTitle' "$tpath" 2>/dev/null | tail -1)

# 2. Fall back to the live runtime name (background-job names, in-process /rename).
[ -n "$name" ] || name=$(jq -r --arg sid "$sid" \
  'select(.sessionId == $sid) | .name // empty' \
  "$HOME"/.claude/sessions/*.json 2>/dev/null | head -1)

# 3. Fall back to the project directory name when nothing else is set yet.
[ -n "$name" ] || name=$(basename "$(printf '%s' "$input" | jq -r '.cwd // empty')")
[ -n "$name" ] || exit 0

# No-op if the session is already named this.
[ "$name" = "${ZELLIJ_SESSION_NAME:-}" ] && exit 0

# Defensive timeout so an unresponsive zellij server can never stall the turn.
timeout 3 zellij action rename-session "$name" >/dev/null 2>&1 || true
