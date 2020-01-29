#!/bin/sh 

rm -rf proc && mkdir -p proc && \
rm -rf dist && mkdir -p dist && \
find src/posts -type f | sort -r \
    | xargs sed -E '/^Tags:/s|(.*)|\1\n|' \
    | sed -E '/^Tags:/s|([^:,])\s|\1-|g' \
    | sed -E '/^Tags:/s|\s([^,]+)(,\|$)|\L link:tags/\1.html[\1]|g' \
    | sed -E 's|^Tags|link:tags/index.html[Tags]|' \
> proc/posts.adoc

asciidoctor -o - src/index.adoc > dist/index.html
