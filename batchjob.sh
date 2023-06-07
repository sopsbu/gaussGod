#!/bin/bash

echo "This option is designed for sequentally numbered .gjf files."
echo "If * appears before prompt, press enter for default."

#defaults subject to change
dfltEmail="scs8802@nyu.edu"
dfltNodes=1
dfltMem="50GB"
gaussMod="gaussian/intel/g16c01"
gaussModCommand="run-gaussian"

read -p "*email: " pemail
case "$pemail" in
    "") email="$dfltEmail"; break;;
    *) email="$pemail"; break;;
esac
read -p "job name: " jname
read -p "*nodes (usually 1): " pnodes
case "$pnodes" in
    "") nodes="$dfltNodes"; break;;
    *) nodes="$pnodes"; break;;
esac
read -p "cpus-per-task: " cpus
read -p "time (168 hours max): " t
read -p "*memory ('#GB'): " pmem
case "$pmem" in
    "") mem="$dfltMem"; break;;
    *) mem="$pmem"; break;;
esac
read -p "*Gaussian? y or n: " ny
case "$ny" in
    "") module="$gaussMod"; modCommand="$gaussModCommand"; break;;
    "y") module="$gaussMod"; modCommand="$gaussModCommand"; break;;
    "n") read -p "enter module load pathway (excluding'module load'): " otherMod;
        module="$otherMod"; 
        read -p "enter module signature command ('run-gaussian'...): " otherModCommand;
        modCommand="$otherModCommand";
        break;;
esac
read -p "first number of sequentially numbered files: " val1
read -p "last number of sequentially numbered files: " val2
read -p "*do you have character(s) in the name of your files? y or n: " yn
case "$yn" in
    "y") read -p "1.Before the number, 2.After, or 3.Both? 1, 2, or 3: " beforeAfter; 
        case "$beforeAfter" in
            "1") read -p "type the character(s) before the number(s) exactly as they appear: " Bchar; 
                echo "character before is set to "$Bchar""; break;;
            "2") read -p "type the character(s) after the number(s) exactly as they appear: " charA; 
                echo "character after is set to "$charA"";break;;
            "3") read -p "type the character(s) before the number(s) exactly as they appear: " Bchar; 
                echo "character before is set to "$Bchar"";
                read -p "type the character(s) after the number(s) exactly as they appear: " charA; 
                echo "character after is set to "$charA""; break;;
        esac
        ;;
    *) echo "no character"; break;;
esac

echo "#!/bin/bash" > "$jname"'job.s'
echo "#" >> "$jname"'job.s'
echo "#SBATCH --mail-type=ALL" >> "$jname"'job.s'
echo "#SBATCH --mail-user="$email"" >> "$jname"'job.s'
echo "#SBATCH --job-name="$jname"" >> "$jname"'job.s'
echo "#SBATCH --nodes="$nodes"" >> "$jname"'job.s'
echo "#SBATCH --cpus-per-task="$cpus"" >> "$jname"'job.s'
echo "#SBATCH --time="$t":00:00" >> "$jname"'job.s'
echo "#SBATCH --mem="$mem"" >> "$jname"'job.s'
echo "#SBATCH --output=mpi_test_%j.out" >> "$jname"'job.s'
echo >> "$jname"'job.s'
echo "module purge" >> "$jname"'job.s'
echo "module load "$module"" >> "$jname"'job.s'
echo >> "$jname"'job.s'
echo "cd "$futurePath"" >> "$jname"'job.s'
echo "for i in {"$val1".."$val2"}" >> "$jname"'job.s'
echo "do" >> "$jname"'job.s'
if [[ -n ${Bchar} && -n ${charA} ]]; then
    echo "$modCommand" "$Bchar"'${i}'"$charA"'.com > '"$Bchar"'${i}'"$charA"'.log 2>&1' >> "$jname"'job.s'
elif [[ -n ${Bchar} && -z ${charA} ]]; then
    echo "$modCommand" "$Bchar"'${i}.com > '"$Bchar"'${i}.log 2>&1' >> "$jname"'job.s'
elif [[ -z ${Bchar} && -n ${charA} ]]; then
    echo "$modCommand" '${i}'"$charA"'.com > ${i}'"$charA"'.log 2>&1' >> "$jname"'job.s'
else [[ -z ${Bchar} && -z ${charA} ]]
    echo "$modCommand" '${i}.com > ${i}.log 2>&1' >> "$jname"'job.s'
fi
echo "done" >> "$jname"'job.s'

mv "$jname"'job.s' "$newDir";

echo "Outputs automatically have the same names as inputs."