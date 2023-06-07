#!/bin/bash

#pwd='/Users/sophiasburlati/Desktop/notesAndScripts/scriptPractice/*.gjf'

# variable option for different keywords
## MAKE SURE TO LEAVE ~ IN QUOTES

read -p "enter frequency in nm ('#nm'): " freq

echo "Check keywords. If they are not desirable, press 'enter' to quit and edit script."
kw='~#n cam-b3lyp/def2qzvp nosymm polar=optrot cphf(rdfreq) iop(10/46=7)'
echo "$kw"

for i in $pathway
do
    val=$(awk -F"[/.]" '{NF--;print $NF}' <<<"${i}")
    valDigit=$(echo "$val" | tr -cd [0-9])
    sed 's~'^%.*'~%chk='"$valDigit"'.chk~g' $i >> "$valDigit"'inter1.gjf'
    sed '2 s~'.*"$kw"'~g' "$valDigit"'inter1.gjf' >> "$valDigit"'sp.gjf'
    rm "$valDigit"'inter1.gjf'
    title=$(awk 'NR==4' "$i")

    mo=`grep -n ' [[:upper:]]\|[0-9]\|[a-z]' "$i" | tail -1`
    ln=`echo "$mo" | awk -F: '{print $1}'`
    pro=`echo "$mo" | awk -F: '{print $2}'`

    if [[ "$pro" =~ ^[0-9] ]]; then
        sed -i.bak "$ln"' s~'.*"~$freq"'~g' "$valDigit"'sp.gjf'
        echo "got it :P"
    elif [[ "$pro" =~ ^' ' ]]; then
        echo >> "$valDigit"'sp.gjf'
        echo >> "$valDigit"'sp.gjf'
        echo >> "$valDigit"'sp.gjf'
        nln=$((ln+2))
        sed -i.bak "$nln"' s~'.*"~$freq"'~g' "$valDigit"'sp.gjf'
        echo "slayed"
    elif [[ "$pro" =~ ^[a-z] ]]; then
        sed -i.bak "$ln"' s~'.*"~$freq"'~g' "$valDigit"'sp.gjf'
        echo "threat neutralized"
    fi

    if [[ "$title" != "$val" ]]; then
        sed -i.bak '4 s~'.*"~$valDigit"'~g' "$valDigit"'sp.gjf'
    fi
    
    mv "$valDigit"'sp.gjf' "$shortPath"

    rm *'gjf.bak'
done