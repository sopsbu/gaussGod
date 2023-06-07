#!/bin/bash

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
read -p "*Gaussian? y or n: " yn
case "$yn" in
    "") module="$gaussMod"; modCommand="$gaussModCommand"; break;;
    "y") module="$gaussMod"; modCommand="$gaussModCommand"; break;;
    "n") read -p "Enter module load pathway (excluding'module load'): " otherMod;
        module="$otherMod"; 
        read -p "Enter module signature command ('run-gaussian'...): " otherModCommand;
        modCommand="$otherModCommand";
        break;;
esac
read -p "*.com file name (DON'T include '.com'): " pcom
case "$pcom" in
    "") com="$jname"; break;;
    *) com="$pcom"; break;;
esac
read -p "*.log file name (DON'T include '.log'): " plog
case "$plog" in
    "") log="$jname"; break;;
    *) log="$plog"; break;;
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
echo >> "$jname"'job.s'
echo ""$modCommand" "$com".com > "$log".log 2>&1" >> "$jname"'job.s'

mv "$jname"'job.s' "$newDir";