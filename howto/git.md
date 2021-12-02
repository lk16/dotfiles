
# Git

```sh
# Stop tracking branches that no longer exist on origin (aka GitLab)
git remote prune origin

# Remove all branches (except blacklisted ones) that are already merged into master
git branch -a --merge master | egrep -v 'master|pre-release|release' | xargs git branch -d
```
