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
