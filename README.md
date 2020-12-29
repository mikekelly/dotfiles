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

Powerline:
```bash
brew install python
brew install vim
pip install powerline-status
```
Powerline fonts: [https://github.com/Lokaltog/powerline-fonts](https://github.com/Lokaltog/powerline-fonts)

Janus:
```bash
curl -Lo- https://bit.ly/janus-bootstrap | bash
```

Additional brews:
```bash
brew install bash rbenv ruby-build wget postgresql pkg-config ack autoconf \
automake ctags curl libevent ossp-uuid readline reattach-to-user-namespace
```
