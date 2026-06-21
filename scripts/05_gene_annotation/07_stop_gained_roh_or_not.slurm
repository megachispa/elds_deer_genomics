#!/bin/bash
#SBATCH --job-name=top
#SBATCH --output=top_%j.out
#SBATCH --error=top_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

# Activate conda
source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR" || exit 1

# HIGH-impact variants homozygous alternate in >=2 individuals
awk '$1>=2' high_genomewide_ranked.tsv > high_common.tsv

# stop_gained variants homozygous alternate in >=2 individuals
awk '$1>=2 && $4 ~ /stop_gained/' high_genomewide_ranked.tsv \
> stop_gained_common.tsv


awk -F'\t' '
{
    split($4,a,"|")

    consequence=a[2]
    gene=a[4]
    transcript=a[7]
    cds=a[10]
    protein=a[11]

    print $1"\t"$2"\t"$3"\t"gene"\t"consequence"\t"protein
}
' stop_gained_common.tsv \
> stop_gained_summary.tsv


#Create gene ID ↔ gene name table

grep -P "\tmRNA\t" /mnt/tank/scratch/ebarabanova/annotation/gemoma_output/final_annotation.gff \
| awk -F'\t' '
{
    match($9,/Parent=([^;]+)/,a)
    match($9,/ref-gene=([^;]+)/,b)

    if(a[1] && b[1])
        print a[1]"\t"b[1]
}
' \
| sort -u \
> gene_names.tsv


#Add gene names to stop-gained table

awk '
BEGIN{
    OFS="\t"
}
FNR==NR{
    name[$1]=$2
    next
}
NR==1{
    print $0,"GENE_NAME"
    next
}
{
    print $0,(($4 in name)?name[$4]:"NA")
}
' gene_names.tsv stop_gained_summary.tsv \
> stop_gained_summary_named.tsv


#Convert stop-gained variants to bed file
awk 'BEGIN{OFS="\t"}
NR>1{
    print $2,$3-1,$3
}
' stop_gained_summary_named.tsv \
> stop_gained.bed

#Find variants intersecting with ROH 
bedtools intersect \
-u \
-a stop_gained.bed \
-b /mnt/tank/scratch/ebarabanova/roh/roh_gt1Mb.bed \
> stop_gained_in_roh.bed

#Add the ROH column
awk '
BEGIN{
    OFS="\t"
}
FNR==NR{
    roh[$1":"$3]=1
    next
}
FNR==1{
    print $0,"IN_ROH"
    next
}
{
    key=$2":"$3

    if(key in roh)
        print $0,"YES"
    else
        print $0,"NO"
}
' stop_gained_in_roh.bed stop_gained_summary_named.tsv \
> stop_gained_summary_named_roh.tsv
