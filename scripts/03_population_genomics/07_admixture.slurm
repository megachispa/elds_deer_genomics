#!/bin/bash
#SBATCH --job-name=admix
#SBATCH --output=admix_%j.out
#SBATCH --error=admix_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G

set -e

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

WORKDIR=/mnt/tank/scratch/ebarabanova/heterozygosity
cd "$WORKDIR" || exit 1

########################################
# Create LD-pruned dataset for ADMIXTURE
########################################

plink \
    --bfile elds_deer \
    --extract elds_deer_pruned.prune.in \
    --make-bed \
    --allow-extra-chr \
    --out elds_deer_admixture

########################################
# Recode scaffold names to integers
########################################

cp elds_deer_admixture.bim elds_deer_admixture.bim.backup

awk '
BEGIN { OFS="\t" }
{
    if (!($1 in chr)) {
        chr[$1] = ++n
    }
    $1 = chr[$1]
    print
}
' elds_deer_admixture.bim.backup > elds_deer_admixture.bim

########################################
# Run ADMIXTURE
########################################

for K in 1 2 3 4 5
do
    admixture --cv=10 elds_deer_admixture.bed $K | tee log${K}.out
done

########################################
# Collect CV errors
########################################

grep -h "CV error" log*.out > cv_errors.txt
