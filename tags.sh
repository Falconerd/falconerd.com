#!/bin/sh

DIR=dist/tags

# get all tag lines
# remove "Tags: " and lowercase
# replace inner-spaces with hyphen
# replace ", " with newline
# sort
# remove duplicates

# Create a list of tags in lowercase with no spaces
rm -rf $DIR && mkdir -p $DIR && \
find src/posts -type f \
    | xargs grep -h '^Tags:.*$' \
    | sed -E 's|^Tags:\s(.*)|\L\1|' \
    | sed -E 's|([^:,])\s|\1-|g' \
    | sed -E 's|,\s|\n|g' \
    | sort \
    | uniq \
    > proc/tags.txt

# Create files
sed -E 's|^(.*)$|\1.html|' proc/tags.txt \
    | sed -E 's|^(.*).html$|dist/tags/\1.html|' \
    | xargs touch

TAGS=`cat proc/tags.txt`
POSTS=`find src/posts -type f`

rm -rf proc
mkdir -p proc/tags

for i in $TAGS
do
    # Setup tags file
    printf "= %s\n" $i >> proc/tags/$i.adoc
    printf ":stylesheet: ../../src/style.css\n" >> proc/tags/$i.adoc

    for j in $POSTS
    do
        grep -h '^Tags:.*$' $j \
            | sed -E 's|^Tags:\s(.*)|\L\1|' \
            | sed -E 's|([^,])\s|\1-|g' \
            | sed -E 's|,\s|\n|g' > proc/post_tags.txt

        if [ -n "`grep -e '^'$i'$' proc/post_tags.txt`" ]
        then
            printf "\ninclude::../../%s[]\n" $j >> proc/tags/$i.adoc
        fi
    done

    asciidoctor proc/tags/$i.adoc -o dist/tags/$i.html
done

