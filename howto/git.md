
# Git

Get rid of branches already merged into master:
```sh
# Remove local branches
git branch --merged origin/master | egrep -v 'master|pre-release|release' | xargs git branch -d

# Remove branches on remote
git branch -r --merged origin/master | egrep '^  origin/' | grep -v master | cut -d"/" -f 2 | xargs git push origin --delete

# Remove remote branches we track locally
git remote prune origin
```
