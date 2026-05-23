#!/bin/bash
#SBATCH --job-name=match_matrix
#SBATCH --output=match_matrix_%j.out
#SBATCH --error=match_matrix_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

# Activate conda
source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

WORKDIR=/mnt/tank/scratch/ebarabanova/roh
cd "$WORKDIR"

#  Identify matching ROHs as ROHs shared by at least 2 individuals (same logic as in detection of ROH islands, but frecuency is down to 2/8=0.25)

awk 'BEGIN{OFS="\t"} $5>=0.25 {
print $1,$2,$3,$5
}' roh_window_freq.txt > shared_by2ormore.bed

# Sort the bed file and merge adjacent windows

sort -k1,1 -k2,2n shared_by2ormore.bed > shared_by2ormore_sorted.bed

bedtools merge \
-i shared_by2ormore_sorted.bed \
-c 4 \
-o mean \
> shared_merged.bed

# Calculate length of shared ROH segments and create a column with the length value

awk '{
print $1"\t"$2"\t"$3"\t"$4"\t"($3-$2)/1000000
}' shared_merged.bed > shared_by2ormore_length.txt

echo "Detection of ROHs shared by 2 or more individuals complete."

#Add IDs to shared ROH islands and replace the frecuency column by the island ID column

awk 'BEGIN{OFS="\t"} {print $1,$2,$3,"island"NR,$5}' \
shared_by2ormore_length.txt > shared_by2ormore_ID.bed

#Intersect shared (by at least 2 individuals) ROHs with individual ROHs

bedtools intersect \
-a shared_by2ormore_ID.bed \
-b roh_gt1Mb_sorted.bed \
-wa -wb > match.txt

# -wa -wb means keep the full entry from file a and the full entry from file b

#Extract shared roh + deer + shared roh length
awk '{print $4,$9,$5}' match.txt | sort -u > match_deer_length.txt

#Build pairwise shared ROH matrix
awk '
{
island=$1
deer=$2
len[island]=$3
a[island]=a[island]" "deer
deers[deer]=1
}

END{

# list deer
n=0
for(d in deers){
list[n++]=d
}

# initialize matrix
for(i=0;i<n;i++){
for(j=0;j<n;j++){
mat[list[i],list[j]]=0
}
}

# add shared ROH length
for(i in a){
split(a[i],b," ")
for(x in b){
for(y in b){
if(b[x]!="" && b[y]!="" && b[x]!=b[y]){
mat[b[x],b[y]]+=len[i]
}
}
}
}

# print header
printf "Deer"
for(i=0;i<n;i++) printf "\t%s",list[i]
print ""

# print matrix
for(i=0;i<n;i++){
printf "%s",list[i]
for(j=0;j<n;j++){
printf "\t%.2f",mat[list[i],list[j]]
}
print ""
}

}' match_deer_length.txt > match_matrix.tsv
