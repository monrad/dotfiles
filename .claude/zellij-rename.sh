#!/usr/bin/env bash
# Mirror the Claude session /rename title into the zellij session name.
# Wired to SessionStart / UserPromptSubmit hooks. Reads the hook JSON from
# stdin, resolves the session's title (set via /rename) from the transcript,
# and renames the current zellij session to match.
#
# Limitation: no hook fires on /rename itself, so the name syncs on your next
# prompt after renaming, not the instant you type /rename.
#
# Routing note (the load-bearing detail): `zellij action` locates the session's
# IPC socket via $ZELLIJ_SESSION_NAME, but that var is frozen at shell launch.
# Our OWN successful rename makes it stale -- it then points at a name with no
# live socket, so the next `zellij action` blocks until killed by `timeout`.
# To stay routable across repeated renames we track the current name in a
# per-session statefile (keyed by Claude session_id, seeded from the launch-time
# $ZELLIJ_SESSION_NAME) and route through that instead of the frozen env var.
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

# Resolve this session's CURRENT zellij name. Prefer the tracked statefile (what
# we last renamed it to == the live name); fall back to the launch-time env var,
# which is only accurate before our first rename. This is what we route through.
state_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zellij-rename"
state_file="$state_dir/$sid"
current=$(cat "$state_file" 2>/dev/null || true)
[ -n "$current" ] || current="$ZELLIJ_SESSION_NAME"

# No-op if the session is already named this.
[ "$name" = "$current" ] && exit 0

# Only attempt the rename if our routing handle is a live session. A stale
# handle (e.g. someone renamed the session out-of-band) has no socket and would
# block until the timeout fires on every turn -- skip it instead of stalling.
live=$(zellij list-sessions 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | awk '{print $1}')
printf '%s\n' "$live" | grep -qxF "$current" || exit 0

# Defensive timeout so an unresponsive zellij server can never stall the turn.
# Route via $current (the live name), not the frozen $ZELLIJ_SESSION_NAME.
if ZELLIJ_SESSION_NAME="$current" timeout 3 \
     zellij action rename-session "$name" >/dev/null 2>&1; then
  mkdir -p "$state_dir"
  printf '%s' "$name" >"$state_file"
fi
