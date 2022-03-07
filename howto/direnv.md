
# Direnv

### Installation:

* `sudo apt-get install direnv`
* Follow [instructions](https://direnv.net/docs/hook.html) for your shell
* Be sure to reload your shell config (for bash run `. ~/.bashrc`)

### Usage with poetry
Follow these steps in the repo root of your poetry project
* Save [this file](../dotfiles/direnv/rc.sh) in `.direnvrc` in your homefolder
* Create a file `.envrc` containing the text `layout_poetry`
* Run `direnv allow`
* Your poetry environment will activate when entering your repo project. You will never have to type `poetry shell` again!
