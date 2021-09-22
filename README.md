
# Notes

This repo contains:
* `dotfiles`: dotfiles and other config files
* `howto`: commands and tricks, somewhat unorganized
* `tools`: a few of python scripts that do


## Setup dotfiles and tools
* Clone this repo
* From repo root run `./install.sh`

## Tools
These are run with `tools <command>`
* `check-common-tools`: check if my commonly used tools are installed
* `check-external-dependencies`: check if external binaries that this project runs are installed
* `csvcut`: very basic verison of UNIX `cut` but for CSV files
* `get-statusbar`: generate tmux statusbar items, see more info below
* `highlight`: reads lines from stdin and outputs those lines on stdout highlighting terms in various colors specified by flags
* `new-daily-notes`: creates a new notes file from yesterday's notes
* `vscode-extensions`: list/edit/save a list of VS Code extensions
* `tmux-broadcast`: send a command to every window/pane in a tmux session

## Tmux status bar items
* `battery`: displays how much your laptop battery is charged
* `date`: the current date
* `spotify`: current spotify song playing: artist and song title. Hidden if spotify is not running.
* `weather`: current weather

## Links
- [Markdown viewer browser plugin](https://chrome.google.com/webstore/detail/markdown-viewer/ckkdlimhmcjmikdlpkmbgfkaikojcbjk?hl=en)
- [Markdown diagrams](https://mermaid-js.github.io/mermaid/#/)
- https://peterforgacs.github.io/2017/04/25/Tmux/
- https://github.com/sbernheim4/dotfiles
- https://github.com/ahf/dotfiles
