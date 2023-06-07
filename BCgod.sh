#!/bin/bash

read -p "Pathway to local directory with /*.gjf: " pathway
shortPath=`echo "$pathway" | cut -d "*" -f 1`;
printf "$shortPath\n" > shortPathV.txt

read -p "Enter index of calculaiton type: 1.Optimization 2.Single Point 3.Rotatory Strength " calc 
case "$calc" in 
    "1") chmod u+x OPT.sh; export pathway; export shortPath; sh OPT.sh; break
        ;;
    "2") chmod u+x SP.sh; export pathway; export shortPath; sh SP.sh; break
        ;;
    "3") chmod u+x RS.sh; export pathway; export shortPath; sh RS.sh; break
        ;;
    "") echo "empty"; break;;
    *) echo "try harder";;
esac
printf "$calc\n" >  calcV.txt

#convert .gjf to .com
dfltnetID="scs8802"
dfltcPath="/scratch/scs8802"

read -p "Do you want to convert .gjf(s) into .com(s)? y or n: " yuhnuh
case "$yuhnuh" in
    "y") echo "If * appears before prompt, press enter for default." 
        read -p "enter the name of a new directory for .com(s): " newDirN ;
        newDir="${shortPath}${newDirN}";
        echo "$newDir";
        read -p "*NetID: " pnetID
        case "$pnetID" in
            "") netID="$dfltnetID"; break;;
            *) netID="$pnetID"; break;;
        esac
        read -p "*is cluster pathway '/scratch/NetId'? y or n: " yesorno
        case "$yesorno" in
            "") cPath="$dfltcPath"; echo $cPath; break;;
            "y") cPath="/scratch/""$netID"; echo $cPath; break;;
            "n") read -p "*cluster pathway to .com (/scratch/...): " cPath; echo "$cPath"; break;;
        esac
        printf "$newDir\n" > newDirV.txt
        futurePath=""${cPath}"/"${newDirN}""
        printf "$futurePath\n" >  futurePathV.txt
        chmod u+x gjf2com.sh; export calc; export pathway; export shortPath; export newDirN; export newDir; sh gjf2com.sh; break;;
    *) echo "whatevs"; break;;
esac

jobs=("1.Single job 2.Batch job")
read -p "Do you need a job script? y or n: " respuesta
case "$respuesta" in
    "y") echo "$jobs"; 
        read -p "Enter index of job type: " kind ;
        case "$kind" in
            "1") chmod u+x singlejob.sh; export futurePath; export pathway; export newDir; sh singlejob.sh; break;;
            "2") chmod u+x batchjob.sh; export futurePath; export pathway; export newDir; sh batchjob.sh; break
        esac
        ;;
    "n") echo "heard, boss"; break;;
    "") echo "empty"; break;;
    *) echo "try harder";;
esac

read -p "scp it all over? y or n: " yerner
case "$yerner" in
    "y") scp -rO "$newDir" "$netID"'@greene.hpc.nyu.edu:'"$cPath"; break;;
    *) echo "coolio"; break;;
esac

txtPath=${PWD}"/*.txt"
for i in $txtPath
do 
    mv ${i} "$shortPath"
done

echo "god speed, soldier"

# if there is more than one .gjf in the pathway with the same 
# $valDigit, two copies of coordinates will be printed into one file
# next: maybe try to find a way to avoid this
#   if 3opt.gjf already exists, name it 3b.gjf or whatever
