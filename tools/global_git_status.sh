#!/bin/bash

# TODO make this a python script
# TODO use -maxdepth 4 to cover ~/projects/INACTIEF

GIT_REPOS=$(find ~ -maxdepth 3 -name .git -type d -prune -exec dirname {} \;)

dirty_repos=0
repos=0

for repo in $GIT_REPOS; do
    status=$(git -C $repo status -s)
    if [[ ! -z $status ]]; then
        branch_name=$(git -C $repo rev-parse --abbrev-ref HEAD)
        echo -e "\033[1;31m$repo @ $branch_name\033[0m"
        echo $status
        echo
        dirty_repos=$(expr $dirty_repos + 1)
    # TODO git push dryrun is slow, consider caching somehow
    #elif ! git push --all origin --dry-run; then
    #    dirty_repos=$(expr $dirty_repos + 1)
    fi
    repos=$(expr $repos + 1)
done

if [[ $dirty_repos -eq 0 ]]; then
    echo -e "\033[1;32mChecked $repos repositories."
else
    echo -e "\033[1;31mChecked $repos repositories. Found $dirty_repos dirty repositories.\033[0m"
    exit 1
fi
