These are my dotfiles that are OSX oriented.

Setup:

My home directory is a git repo. Install it like this:
```bash
cd ~
git init
git remote add origin git@github.com:mikekelly/dotfiles.git
git pull origin master
```
To avoid noise, make sure git ignores all files by adding a `*` line to
`~/.git/info/exclude`.

Vim:
```
brew install vim
```

Janus:
```bash
curl -Lo- https://bit.ly/janus-bootstrap | bash
```

Powerline:
```bash
brew install python@3.9
pip3 install powerline-status
```

Powerline fonts:
* https://gist.github.com/lujiacn/32b598b1a6a43c996cbd93d42d466466
* https://github.com/Lokaltog/powerline-fonts

Additional brews:
```bash
brew install bash wget pkg-config ack autoconf \
                  automake ctags curl libevent ossp-uuid readline reattach-to-user-namespace
```
