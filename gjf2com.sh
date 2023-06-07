#!/bin/bash

cd "$shortPath"
mkdir -p "$newDirN"
echo "$calc"

if [ $calc -eq 1 ]; then 
    pp="$shortPath"'*opt.gjf'
    for i in $pp
    do
        name=$(awk 'NR==4' "$i")
        cp "$i" "$name"'.com'
        cp "$name"'.com' "$newDirN"
        rm *'.com'
    done
elif [ $calc -eq 2 ]; then
    pp="$shortPath"'*sp.gjf'
    for i in $pp
    do
        name=$(awk 'NR==4' "$i")
        cp "$i" "$name"'.com'
        cp "$name"'.com' "$newDirN"
        rm *'.com'
    done
elif [ $calc -eq 3 ]; then 
    pp="$shortPath"'*rs.gjf'
    for i in $pp
    do
        name=$(awk 'NR==4' "$i")
        cp "$i" "$name"'.com'
        cp "$name"'.com' "$newDirN"
        rm *'.com'
    done
fi

