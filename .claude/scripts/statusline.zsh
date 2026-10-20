#!/usr/bin/env zsh
# Claude Code status line:
#   owner/repo | +added -removed N files ↑ahead ↓behind vs origin/main | worktree | ctx % | 5h % | 7d %

input=$(cat)

C_RESET=$'\e[0m'
C_DIM=$'\e[38;5;245m'
C_REPO=$'\e[38;5;74m'
C_ADD=$'\e[38;5;71m'
C_DEL=$'\e[38;5;167m'
C_WT=$'\e[38;5;139m'

# Colour a percentage green/yellow/red by how close it is to the limit
pct_color() {
  local p=${1%.*}
  if (( p >= 80 )); then print -n $'\e[38;5;167m'
  elif (( p >= 50 )); then print -n $'\e[38;5;179m'
  else print -n $'\e[38;5;71m'
  fi
}

fmt_pct() {
  local label=$1 value=$2
  if [[ -z $value ]]; then
    print -n "${C_DIM}${label} –${C_RESET}"
  else
    value=$(printf '%.0f' "$value")
    print -n "${C_DIM}${label} $(pct_color $value)${value}%${C_RESET}"
  fi
}

# Unit separator rather than tab: IFS whitespace would collapse empty fields
IFS=$'\x1f' read -r cwd wt_name gh_repo ctx five week <<<"$(print -r -- "$input" | jq -r '[
  (.workspace.current_dir // .cwd // ""),
  (.worktree.name // ""),
  (.workspace.repo | if . then "\(.owner)/\(.name)" else "" end),
  (.context_window.used_percentage // "" | tostring),
  (.rate_limits.five_hour.used_percentage // "" | tostring),
  (.rate_limits.seven_day.used_percentage // "" | tostring)
] | join("\u001f")')"

parts=()

if [[ -n $cwd ]] && git -C "$cwd" rev-parse --is-inside-work-tree &>/dev/null; then
  g() { git -C "$cwd" --no-optional-locks "$@" 2>/dev/null }

  # GitHub repo from the origin URL (git@github.com:o/r.git or https://github.com/o/r)
  repo=$gh_repo
  if [[ -z $repo ]]; then
    url=$(g remote get-url origin)
    repo=${url%.git}
    repo=${repo#*github.com[:/]}
    [[ $repo == $url || -z $url ]] && repo=${$(g rev-parse --show-toplevel):t}
  fi
  parts+=("${C_REPO}${repo}${C_RESET}")

  # Diff summary against the default branch (origin/HEAD, else origin/main)
  base=$(g rev-parse --abbrev-ref origin/HEAD)
  [[ -z $base ]] && base=origin/main
  if g rev-parse --verify -q "$base" >/dev/null; then
    mb=$(g merge-base "$base" HEAD)
    stat=$(g diff --shortstat "$mb")
    files=${${(M)stat:#*file*}:+${${stat## }%% file*}}
    add=0 del=0
    [[ $stat =~ '([0-9]+) insertion' ]] && add=$match[1]
    [[ $stat =~ '([0-9]+) deletion' ]] && del=$match[1]
    IFS=$'\t' read -r ahead behind <<<"$(g rev-list --left-right --count HEAD..."$base")"
    if [[ -z $stat && $ahead == 0 && $behind == 0 ]]; then
      diff="${C_DIM}=${C_RESET}"
    else
      diff="${C_ADD}+${add}${C_RESET} ${C_DEL}-${del}${C_RESET}${C_DIM} ${files:-0}f"
      (( ahead > 0 )) && diff+=" ↑${ahead}"
      (( behind > 0 )) && diff+=" ↓${behind}"
      diff+="${C_RESET}"
    fi
    parts+=("$diff")
  else
    parts+=("${C_DIM}no ${base}${C_RESET}")
  fi

  # Worktree: Claude's own worktree name, else a linked git worktree's dir name
  if [[ -z $wt_name ]]; then
    gitdir=$(g rev-parse --absolute-git-dir)
    common=$(cd "$cwd" && git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
    [[ -n $gitdir && $gitdir != $common ]] && wt_name=${$(g rev-parse --show-toplevel):t}
  fi
  if [[ -n $wt_name ]]; then
    parts+=("${C_WT}⎇ ${wt_name}${C_RESET}")
  else
    parts+=("${C_DIM}no worktree${C_RESET}")
  fi
else
  parts+=("${C_DIM}no git (${(D)cwd})${C_RESET}")
fi

parts+=("$(fmt_pct ctx "$ctx")" "$(fmt_pct 5h "$five")" "$(fmt_pct 7d "$week")")

sep=" ${C_DIM}│${C_RESET} "
print -rn -- "${(pj:$sep:)parts}"
