
# Direnv

### Installation:

* `sudo apt-get install direnv`
* Follow [instructions](https://direnv.net/docs/hook.html) for your shell
* Be sure to reload your shell config (for bash run `. ~/.bashrc`)

### Usage with poetry
Setup config for poetry with direnv:
* Save [this file](../dotfiles/direnv/rc.sh) in `.direnvrc` in your homefolder

Setup inside for your poetry project, run from the repo root.
* Create a file `.envrc` in your poetry project root containing the text `layout_poetry`
* Run `direnv allow`
* Your poetry environment will activate when entering your repo project and deactivate when you leave.
* You will never have to type `poetry shell` again!
