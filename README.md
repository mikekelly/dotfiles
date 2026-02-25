# Dotfiles

macOS-oriented dotfiles managed with a bare git repo.

## How it works

A bare git repo lives at `~/.dotfiles` with `$HOME` as the work tree. The `dot` alias wraps git to target this repo:

```bash
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
```

This avoids putting a `.git` directory in `$HOME`, so editors, prompts, and scripts in `$HOME` or non-repo subdirectories don't pick up the dotfiles repo.

## Setup on a new machine

```bash
git clone --bare git@github.com:mikekelly/dotfiles.git ~/.dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
dot checkout
dot config status.showUntrackedFiles no
dot submodule update --init --depth=1
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

If `dot checkout` complains about existing files, back them up first:

```bash
dot checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | xargs -I{} mv {} {}.bak
dot checkout
```

## Usage

```bash
dot status
dot add .zshrc
dot commit -m "Update zshrc"
dot push
```
