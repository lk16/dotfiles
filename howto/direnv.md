
# Direnv

### Installation:

* `sudo apt-get install direnv`
* Follow [instructions](https://direnv.net/docs/hook.html) for your shell
* Be sure to reload your shell config (for bash run `. ~/.bashrc`)

### Setup direnv
Setup config for poetry and/or pdm with direnv:
* Save [this file](../dotfiles/direnv/rc.sh) in `.direnvrc` in your homefolder

### Usage with poetry
Setup direnv config using the section above.

Follow these steps from the repo root:
* Create a file `.envrc` containing the text `layout_poetry`
* Run `direnv allow`
* Your poetry environment will activate when entering your repo folder and deactivate when you leave.
* You will never have to type `poetry shell` again!

### Usage with pdm
Setup direnv config using the section above.

Follow these steps from the repo root:
* Create a file `.envrc` containing the text `layout_pdm`
* Run `direnv allow`
* Your pdm environment will activate when entering your repo folder and deactivate when you leave.
* You will never have to type `pdm run` again!
