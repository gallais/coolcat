#!/bin/sh

prefix="src/"

find "$prefix" -name "*.md" >tmp
while IFS= read -r rawfile; do
    file=$(echo "$rawfile" | sed "s|src/\(.*\)|\1|")
    dirs=$(dirname "$file")
    filename=$(basename "$file" ".md")
    mkdir -p build/"$dirs"
    pandoc --lua-filter tools/tikz.lua -s -o build/"$dirs"/"$filename".html src/"$dirs"/"$filename".md
    mv *.svg build/"$dirs" 2>/dev/null
done <tmp
rm tmp
