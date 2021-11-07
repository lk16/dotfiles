#!/bin/bash

# make sure ssh key forwarding works
[ -f ~/.ssh/id_rsa ] && ssh-add ~/.ssh/id_rsa 2>&1 | grep -v 'Identity added:'

# add work key if present
[ -f ~/.ssh/id_rsa_work ] && eval $(keychain --eval id_rsa_work -q)
