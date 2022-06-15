These are my dotfiles that are OSX oriented.

Setup:

My home directory is a git repo. Install it like this:
```bash
cd ~
git init
git remote add origin git@github.com:mikekelly/dotfiles.git
git pull origin master
git submodule update --init --recursive
```

To avoid noise, make sure git ignores all untracked files in this repo:
```
echo "*" >> ~/.git/info/exclude
```

oh-my-zsh:
```
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Janus:
```bash
curl -Lo- https://bit.ly/janus-bootstrap | bash
```

Powerline:
```bash
brew install python && \
  pip install powerline-status
```

Powerline fonts:

https://github.com/Lokaltog/powerline-fonts

Baseline tooling:
```bash
brew install bash vim tmux wget pkg-config ack autoconf \
                  automake ctags curl libevent ossp-uuid \
                  readline reattach-to-user-namespace
```
