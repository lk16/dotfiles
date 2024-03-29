
### Show available aliases, builtins, keywords, functions

```sh
# will list all the aliases you could run.
compgen -a

# will list all the built-ins you could run.
compgen -b

# will list all the keywords you could run.
compgen -k

# will list all the functions you could run.
compgen -A function

# will list all the above in one go.
compgen -A function -abck
```

---

### Check if word is an aliases, builtin, keyword or function

```sh
function myfunction() {
    true
}
alias myalias='true'

# examples
type myalias
type if # keyword
type myfunction
type cd # builtin
type nonexistent
```

---

### Open all files matching some regex in VS Code

```sh
code -r $(git grep -l 'property\.name')
```

---

### Open all files with mypy errors in VS Code

```sh
code --goto $(pre-commit run mypy -a 2>&1 | cut -d ':' -f 1-2 | grep '\.py')
```
