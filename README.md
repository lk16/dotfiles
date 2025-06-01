
# Dotfiles

This repo contains:
* `dotfiles`: configuration files for `tmux`, `git` and `bash`
* A few python scripts

### How to use
* Clone this repo
* Replace `$DOTFILES_ROOT` with absolute path to repo root in these instructions.

##### Bashrc

* Add to your `~/.bashrc`:
```sh
# Load bash config from dotfiles
. $DOTFILES_ROOT/dotfiles/bash/rc.sh
```
* Reload shell:
```sh
. ~/.bashrc
```

##### Git config
* Add these symlinks:
```sh
ln -s $DOTFILES_ROOT/dotfiles/git/config.ini ~/.gitconfig
ln -s $DOTFILES_ROOT/dotfiles/git/ignore ~/.gitignore
```

##### Tmux config

* Setup default tmux statusbar config
```sh
cp -n $DOTFILES_ROOT/tools/statusbar_conf.json.default $DOTFILES_ROOT/tools/statusbar_conf.json
```
* Optional: tweak config
* Install tmux plugin manager and plugins:
```sh
# install tmux plugin manager
if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone -q https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# install tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins
```

* Add symlink
```sh
ln -s $DOTFILES_ROOT/dotfiles/tmux/config.tmux ~/.tmux.conf
```
### Links
- [Markdown viewer browser plugin](https://chrome.google.com/webstore/detail/markdown-viewer/ckkdlimhmcjmikdlpkmbgfkaikojcbjk?hl=en)
- [Markdown diagrams](https://mermaid-js.github.io/mermaid/#/)
- https://peterforgacs.github.io/2017/04/25/Tmux/
- https://github.com/sbernheim4/dotfiles
- https://github.com/ahf/dotfiles
