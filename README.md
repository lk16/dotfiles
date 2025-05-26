
# Dotfiles

This repo contains:
* `dotfiles`: actual dotfiles and other config files.
* `tools`: a few handy python scripts, see tools section below.

## Setup dotfiles and tools
* Clone this repo
* From repo root run `./install.sh`

The install script makes symlinks to the dotfiles in the cloned repo. That way all tracked files stay in the same folder, while applications (such as `bash`) can find the dotfiles where they are expected to be (such as `~/.bashrc`).

The install script also sets up a virtual environment for the tools.

The script is written such that it can be run again if parts of the installation steps are added, without creating any duplicate files or having other ugly side-effects. The script never removes any files.

## Setup white noise hotkey
Configure this command with your prefered hotkey: `bash -ci 'noise'`

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
