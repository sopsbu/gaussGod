# gaussGod
Both scripts automating calculation preparation pre-Gaussian job and analysis scripts for post-job digestion.

BCgod.sh (before calculation) is the parent shell script for formatting .gjf/.com/.s files that calls upon shell scripts OPT.sh, SP.sh, RS.sh, gjf2com.sh, singlejob.sh,and batchjob.s when prompted.

ADgod.sh (after da' calculation) is the parent shell scvript that calls upon OPTanalysis.sh, SPanalysis,sh, amd RSanalysis.sh when prompted.

Always check preset variables (like those for keywords or pathways) before executing scripts.

Check default variables.

$chmod u+x
$sh <script.sh>
