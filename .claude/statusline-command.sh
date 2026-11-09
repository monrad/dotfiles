#!/usr/bin/env bash
# Claude Code status line, two lines in the style of statusline.sh's "triptych":
#   [model]  effort ⚡  dir  branch ◆  · session name
#   ctx ▰▰▱▱ used/size (pct%) · ♦ 7d ▰▱▱ pct% T-reset · cache warm

input=$(cat)
E=$'\033'

# One jq call; one value per line, in this order.
{
    IFS= read -r model
    IFS= read -r effort
    IFS= read -r fast
    IFS= read -r cwd
    IFS= read -r session
    IFS= read -r ctx_pct
    IFS= read -r ctx_used
    IFS= read -r ctx_size
    IFS= read -r week_pct
    IFS= read -r week_reset
    IFS= read -r five_pct
    IFS= read -r five_reset
    IFS= read -r cache_warm
} < <(printf '%s' "$input" | jq -r '
    (.model.display_name // ""),
    (.effort.level // ""),
    (.fast_mode == true | tostring),
    (.workspace.current_dir // .cwd // ""),
    (.session_name // ""),
    (.context_window.used_percentage // "" | tostring),
    (.context_window.total_input_tokens // "" | tostring),
    (.context_window.context_window_size // "" | tostring),
    (.rate_limits.seven_day.used_percentage // "" | tostring),
    (.rate_limits.seven_day.resets_at // "" | tostring),
    (.rate_limits.five_hour.used_percentage // "" | tostring),
    (.rate_limits.five_hour.resets_at // "" | tostring),
    (if .prompt_cache then (.prompt_cache.warm | tostring) else "" end)
' 2>/dev/null)

c() { printf '%s[%sm%s%s[0m' "$E" "$1" "$2" "$E"; }

# Whole part of a JSON number; avoids printf %f, which parses by the locale.
int() {
    local v=${1%%.*}
    case $v in '' | *[!0-9-]* | -) printf '0' ;; *) printf '%d' "$v" ;; esac
}

bar() {
    local p w n i out=""
    p=$(int "$1"); w=$2
    [ "$p" -lt 0 ] && p=0
    [ "$p" -gt 100 ] && p=100
    n=$(( (p * w + 50) / 100 ))
    for ((i = 0; i < n; i++)); do out+="▰"; done
    for ((i = n; i < w; i++)); do out+="▱"; done
    printf '%s' "$out"
}

# Percentage text: plain below 50, yellow from 50, red from 80.
pct() {
    local p
    p=$(int "$1")
    if [ "$p" -ge 80 ]; then c '1;31' "$p%"
    elif [ "$p" -ge 50 ]; then c '1;33' "$p%"
    else c '1' "$p%"; fi
}

tokens() {
    local n
    n=$(int "$1")
    if [ "$n" -lt 1000 ]; then printf '%d' "$n"
    elif [ "$n" -lt 1000000 ]; then
        if [ $(( n % 1000 / 100 )) -eq 0 ]; then printf '%dk' $(( n / 1000 ))
        else printf '%d.%dk' $(( n / 1000 )) $(( n % 1000 / 100 )); fi
    else
        if [ $(( n % 1000000 / 100000 )) -eq 0 ]; then printf '%dM' $(( n / 1000000 ))
        else printf '%d.%dM' $(( n / 1000000 )) $(( n % 1000000 / 100000 )); fi
    fi
}

# Time until an epoch-seconds reset: T-42m, T-2h14m, T-4d03h.
until_reset() {
    local d
    [ -n "$1" ] || return
    d=$(( $(int "$1") - $(date +%s) ))
    [ "$d" -gt 0 ] || return
    if [ "$d" -lt 3600 ]; then printf 'T-%dm' $(( d / 60 ))
    elif [ "$d" -lt 86400 ]; then printf 'T-%dh%02dm' $(( d / 3600 )) $(( d % 3600 / 60 ))
    else printf 'T-%dd%02dh' $(( d / 86400 )) $(( d % 86400 / 3600 )); fi
}

limit() {
    local glyph=$1 label=$2 colour=$3 p=$4 reset=$5 t
    printf '%s %s' "$(c "$colour" "$glyph $label")" "$(c "$colour" "$(bar "$p" 10)")"
    printf ' %s' "$(pct "$p")"
    t=$(until_reset "$reset")
    [ -n "$t" ] && printf ' %s' "$(c '2' "$t")"
}

# ── Line 1 ───────────────────────────────────────────────────────────────────

l1=$(c '1;38;2;252;231;243;48;2;124;45;77' " ${model:-?} ")
[ -n "$effort" ] && l1+="  $(c '1;38;2;236;74;161' "$effort")"
[ "$fast" = true ] && l1+=" $(c '38;2;253;224;71' '⚡')"
[ -n "$cwd" ] && l1+="  $(c '1;38;2;253;186;116' "${cwd##*/}")"

if [ -n "$cwd" ] && git -C "$cwd" --no-optional-locks rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null ||
        git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        l1+=" $(c '3;38;2;254;215;170' "$branch")"
        if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null | head -n1)" ]; then
            l1+=" $(c '1;38;2;251;191;36' '◆')"
        else
            l1+=" $(c '2;38;2;251;146;60' '◇')"
        fi
    fi
fi

if [ -n "$session" ]; then
    [ "${#session}" -gt 40 ] && session="${session:0:39}…"
    l1+="  $(c '2;90' '·') $(c '3;38;2;251;207;232' "$session")"
fi

# ── Line 2 ───────────────────────────────────────────────────────────────────

segs=()

if [ -n "$ctx_pct" ]; then
    s="$(c '2;38;2;251;146;60' 'ctx') $(c '38;2;251;146;60' "$(bar "$ctx_pct" 12)")"
    if [ -n "$ctx_size" ] && [ "$(int "$ctx_size")" -gt 0 ]; then
        s+=" $(c '1' "$(tokens "$ctx_used")/$(tokens "$ctx_size")") ($(pct "$ctx_pct"))"
    else
        s+=" $(pct "$ctx_pct")"
    fi
    segs+=("$s")
fi

[ -n "$week_pct" ] && segs+=("$(limit '♦' '7d' '96' "$week_pct" "$week_reset")")
[ -n "$five_pct" ] && segs+=("$(limit '✦' '5h' '94' "$five_pct" "$five_reset")")

if [ "$cache_warm" = true ]; then
    segs+=("$(c '2;38;2;134;239;172' 'cache warm')")
elif [ "$cache_warm" = false ]; then
    segs+=("$(c '2;90' 'cache cold')")
fi

l2=""
sep=" $(c '2;90' '·') "
for s in "${segs[@]}"; do
    [ -n "$l2" ] && l2+="$sep"
    l2+="$s"
done

printf ' %s\n' "$l1"
[ -n "$l2" ] && printf ' %s\n' "$l2"
exit 0
