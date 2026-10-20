# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh
unalias gap

export EDITOR='nvim'

alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias vimdiff="nvim -d"
alias pip="pip3"
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
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
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
export FASTLANE_USER="mikekelly321@gmail.com"

[[ -f ~/.zshcreds ]] && source ~/.zshcreds

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
