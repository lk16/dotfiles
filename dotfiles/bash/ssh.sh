#!/bin/bash

# make sure ssh key forwarding works
[ -f ~/.ssh/id_rsa ] && eval $(keychain --eval --quiet id_rsa -q)

# add work key if present
[ -f ~/.ssh/id_rsa_work ] && eval $(keychain --eval id_rsa_work -q)
