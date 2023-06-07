#!/bin/bash

#pwd='/Users/sophiasburlati/Desktop/notesAndScripts/scriptPractice/*.gjf'

# variable option for different keywords
## MAKE SURE TO LEAVE ~ IN QUOTES

read -p "enter number of excited states: " excited

echo "Check keywords. If they are not desirable, press 'enter' to quit and edit script."
kw='~#n cam-b3lyp def2qzvp nosymm td (full singlets nstates='"$excited"') iop(9/33=1)'
echo "$kw"

for i in $pathway
do
    val=$(awk -F"[/.]" '{NF--;print $NF}' <<<"${i}")
    valDigit=$(echo "$val" | tr -cd [0-9])
    sed 's~'^%.*'~%chk='"$valDigit"'.chk~g' $i >> "$valDigit"'inter1.gjf'
    sed '2 s~'.*"$kw"'~g' "$valDigit"'inter1.gjf' >> "$valDigit"'rs.gjf'
    rm "$valDigit"'inter1.gjf'
    title=$(awk 'NR==4' "$i")
    
    mo=`grep -n ' [[:upper:]]\|[0-9]\|[a-z]' "$i" | tail -1`
    ln=`echo "$mo" | awk -F: '{print $1}'`
    pro=`echo "$mo" | awk -F: '{print $2}'`

    if [[ "$pro" =~ ^[0-9] ]]; then
        sed -i.bak "$ln"' s~'.*"~$freq"'~g' "$valDigit"'rs.gjf'
        echo "frequency deleted"
    elif [[ "$pro" =~ ^' ' ]]; then
        echo >> "$valDigit"'rs.gjf'
        echo "no frequency found"
    elif [[ "$pro" =~ ^[a-z] ]]; then
        sed -i.bak "$ln"' s~'.*'~ ''~g' "$valDigit"'rs.gjf'
        echo "we got 'em, boys"
    fi

    if [[ "$title" != "$val" ]]; then
        sed -i.bak '4 s~'.*"~$valDigit"'~g' "$valDigit"'rs.gjf'
    fi

    mv "$valDigit"'rs.gjf' "$shortPath"

    rm *'gjf.bak'
done

