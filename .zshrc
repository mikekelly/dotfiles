export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

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

# >>> MCP Agent Mail bd path /Users/mike/.local/bin
if [[ ":$PATH:" != *":/Users/mike/.local/bin:"* ]]; then
  export PATH="/Users/mike/.local/bin:$PATH"
fi
# <<< MCP Agent Mail bd path

# >>> MCP Agent Mail alias
alias am='cd "/Users/mike/code/skeleton-crew/mcp_agent_mail" && scripts/run_server_with_token.sh'
# <<< MCP Agent Mail alias
