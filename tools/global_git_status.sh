#!/bin/bash

# TODO make this a python script
# TODO use -maxdepth 4 to cover ~/projects/INACTIEF

# TODO make sure every branch is pushed

GIT_REPOS=$(find ~ -maxdepth 3 -name .git -type d -prune -exec dirname {} \;)

dirty_repos=0
repos=0

for repo in $GIT_REPOS; do
    if [[ ! -z $(git -C $repo status -s) ]]; then
        branch_name=$(git -C $repo rev-parse --abbrev-ref HEAD)
        echo -e "\033[1;31m$repo @ $branch_name\033[0m"
        git -C $repo status -s
        echo
        dirty_repos=$(expr $dirty_repos + 1)
    fi
    repos=$(expr $repos + 1)
done

if [[ $dirty_repos -eq 0 ]]; then
    echo -en "\033[1;32m"
else
    echo -en "\033[1;31m"
fi

echo -e "Checked $repos repositories."
echo -e "Found $dirty_repos dirty repositories.\033[0m"

if [[ $dirty_repos -ne 0 ]]; then
    exit 1
fi
