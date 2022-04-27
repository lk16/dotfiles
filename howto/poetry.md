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
# You only need to run this command once
pyenv install 3.10.2

# The rest of the commands in this code block should be run
# once for each project where you want to use poetry with pyenv

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

---

### Poetry versioning and git tags

When adding a new feature or bugfix in a repo used (refered from now no as "the library") by other repos:

Before merging the fix/feature:
- Implement the fix/feature to your library
- Update the `version` in the section `[tool.poetry]` in `pyproject.toml` in the root of the library repo
- Be sure this is all included in your branch
- Update the changelog
- Make an PR/MR and get your branch merged

After merging:
- Run `git checkout master` and `git pull`
- Tag the merge commit with the new version: for example `git tag v0.2.3`.
- Confirm that the tag is on the correct commit (run `gg` or similar).
- Push the newly created tag: `git push --tags`.

How to use this new version of the library on another project:
- Update the `[tool.poetry.dependencies]` or `[tool.poetry.dev-dependencies]` in `pyproject.toml` to mention the git tag we just created.
For example: `mylibrary = {git = "https://oauth2:***@githab.com/username/mylibrary.git", tag = "v0.2.3"}`
- Run `poetry update mylibrary` (Replace `mylibrary` with the actual library name.)
