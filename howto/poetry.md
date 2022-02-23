### Setup poetry with .venv

```sh
poetry config --local virtualenvs.in-project true
poetry install
```

---

### Fix poetry TooManyRedirects

[Github issue](https://github.com/python-poetry/poetry/issues/728)

Run these command to fix the issue:

```sh
# remove cache folder
rm -Rf ~/.cache/pypoetry/cache

# reinstall poetry
rm -Rf .venv
poetry install
```

---

### Update poetry and dependencies

```sh
# update poetry
poetry self update

# show outdated dependencies
poetry show -o

# show dependency tree
poetry show --tree

# update dependency to latest version
poetry add sqlalchemy@latest
```

---

### Usage with direnv
[See here](direnv.md)


---

### Poetry with pyenv

Installation of custom python version.
We use python 3.10.2 as an example here.

```sh
# Make pyenv download and install 3.10.2
pyenv install 3.10.2

# Tell pyenv to use 3.10 in this folder
pyenv local 3.10.2

# Tell poetry to use python 3.10
# If this step fails, be sure that ~/.pyenv/shims is in PATH
poetry env use 3.10

# Confirm that the poetry environment has the right version
poetry run python -V

# Continue like usual:
poetry install

# Start working on the project
```
