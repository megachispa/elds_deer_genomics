#!/bin/bash
#SBATCH --job-name=snpeff_top_islands_genes
#SBATCH --output=snpeff_top_islands_genes_%j.out
#SBATCH --error=snpeff_top_islands_genes_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

set -euo pipefail

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR" || exit 1

# Activate conda environment
source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate snpeff_env

# Annotate variants in top ROH islands
snpEff -v deer \
    variants_in_top_islands_genes.vcf \
    > annotated_top_islands_genes_variants.vcf
