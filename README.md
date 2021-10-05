
# Dotfiles

This repo contains:
* `dotfiles`: actual dotfiles and other config files.
* `howto`: commands and tricks, somewhat unorganized.
* `tools`: a few handy python scripts, see tools section below.

## Setup dotfiles and tools
* Clone this repo
* From repo root run `./install.sh`

The install script makes symlinks to the dotfiles in the cloned repo. That way all tracked files stay in the same folder, while applications (such as `bash`) can find the dotfiles where they are expected to be (such as `~/.bashrc`).

The install script also sets up a virtual environment for the tools.

The script is written such that it can be run again if parts of the installation steps are added, without creating any duplicate files or having other ugly side-effects. The script never removes any files.

## Tools
These are run with `tools <command>`.
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
* `machine_stats`: shows CPU and memory usage as well as empty hard disk space

## Links
- [Markdown viewer browser plugin](https://chrome.google.com/webstore/detail/markdown-viewer/ckkdlimhmcjmikdlpkmbgfkaikojcbjk?hl=en)
- [Markdown diagrams](https://mermaid-js.github.io/mermaid/#/)
- https://peterforgacs.github.io/2017/04/25/Tmux/
- https://github.com/sbernheim4/dotfiles
- https://github.com/ahf/dotfiles
