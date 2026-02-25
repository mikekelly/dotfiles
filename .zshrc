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

# bun
[ -s "/Users/mike/.bun/_bun" ] && source "/Users/mike/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# wezterm cli
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
wt() {
  wezterm cli spawn --cwd . --new-window 2>/dev/null
}

# opencode
export PATH=/Users/mike/.opencode/bin:$PATH

# open main worktree
open_main() {
  cd "$(git rev-parse --git-common-dir)/.."
}

# zellij
export PATH="/Users/mike/code/zellij/target/release:$PATH"

# beads
export PATH="$PATH:/Users/mike/.local/bin"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/mike/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
export FASTLANE_USER="mikekelly321@gmail.com"

source ~/.zshcreds

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
