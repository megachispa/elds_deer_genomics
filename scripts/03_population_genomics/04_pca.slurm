#!/bin/bash
#SBATCH --job-name=plink_pca
#SBATCH --output=plink_pca_%j.out
#SBATCH --error=plink_pca_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

# Activate conda environment
source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

cd /mnt/tank/scratch/ebarabanova/heterozygosity

# Convert VCF to PLINK format
plink \
  --vcf /mnt/tank/scratch/ebarabanova/missingness_calculations/final_missingness_filtered.vcf.gz \
  --double-id \
  --allow-extra-chr \
  --make-bed \
  --out elds_deer

# LD pruning
plink \
  --bfile elds_deer \
  --indep-pairwise 50 5 0.2 \
  --allow-extra-chr \
  --out elds_deer_pruned

# PCA
plink \
  --bfile elds_deer \
  --extract elds_deer_pruned.prune.in \
  --pca 10 \
  --allow-extra-chr \
  --out elds_deer_pca
