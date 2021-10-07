#!/bin/bash

# TODO make this a python script

dumpfile=$(mktemp)

for folder in $(find ~ -maxdepth 1 -type d -name gig -o -name projects); do
    for subfolder in $(find $folder -maxdepth 1 -type d); do
        if [ -d "$subfolder/.git" ]; then
            git --no-pager -C $subfolder grep $@ 'TODO' | \
                sed "s,^,$subfolder/," | \
                egrep -v 'notes/work/daily/202(0|1/0)' >> $dumpfile
        fi
    done
done

sort < $dumpfile

rm $dumpfile
