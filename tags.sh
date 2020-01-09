#!/bin/sh

DIR=dist/tags

# get all tag lines
# remove "Tags: " and lowercase
# replace inner-spaces with hyphen
# replace ", " with newline
# sort
# remove duplicates

rm -rf $DIR && mkdir -p $DIR && touch $DIR/index.html && \
find src/posts -type f \
    | xargs grep -h '^Tags:.*$' \
    | sed -E 's|^Tags:\s(.*)|\L\1|' \
    | sed -E 's|([^:,])\s|\1-|g' \
    | sed -E 's|,\s|\n|g' \
    | sort \
    | uniq \
    | sed -E 's|^(.*)$|'$DIR'/\1.html|g' \
    | tee $DIR/index.html \
    | xargs touch


