# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
# (Moved above oh-my-zsh so its compinit picks them up; no second compinit needed.)
fpath=($HOME/.docker/completions $fpath)
# End of Docker CLI completions
source $ZSH/oh-my-zsh.sh
unalias gap

export EDITOR='nvim'

alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias vimdiff="nvim -d"
alias pip="pip3"
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

# Interactive claude: bypass permissions + Remote Control, and a fresh worktree
# (from origin/HEAD) when inside a git repo. Subcommands and -p runs pass
# through untouched; --resume/--continue/-w don't get a new worktree.
# The boolean flag goes last so -w/--remote-control (optional values) can't
# swallow a prompt or flag passed after them.
claude() {
  local sub="agents attach auth auto-mode doctor gateway import install logs mcp plugin purge remote-control respawn rm setup-token stop ultrareview update"
  if [[ -n $1 && " $sub " == *" $1 "* ]] || (( ${@[(I)-p|--print]} )); then
    command claude "$@"
    return
  fi
  local -a flags=(--remote-control --dangerously-skip-permissions)
  if git rev-parse --is-inside-work-tree &>/dev/null \
    && ! (( ${@[(I)-r|--resume|--resume=*|-c|--continue|-w|--worktree|--worktree=*]} )); then
    flags=(-w "${flags[@]}")
  fi
  command claude "${flags[@]}" "$@"
}
compdef _git dot=git

# bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# wezterm cli
[[ -d /Applications/WezTerm.app ]] && PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
wt() {
  wezterm cli spawn --cwd . --new-window 2>/dev/null
}

# open main worktree
open_main() {
  cd "$(git rev-parse --git-common-dir)/.."
}

# zellij
export PATH="$HOME/code/zellij/target/release:$PATH"

# beads, herdr, fd symlink (linux)
export PATH="$HOME/.local/bin:$PATH"
export FASTLANE_USER="mikekelly321@gmail.com"

[[ -f ~/.zshcreds ]] && source ~/.zshcreds

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
