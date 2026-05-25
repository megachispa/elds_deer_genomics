#!/bin/bash
#SBATCH --job-name=snpeff_highimpact
#SBATCH --output=snpeff_highimpact_%j.out
#SBATCH --error=snpeff_highimpact_%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

set -euo pipefail

source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate snpeff_env

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR" || exit 1

VCF_IN="annotated_top_islands_genes_variants.vcf"

#Filter HIGH impact variants using SnpSift (SnpEff suite)

echo "Filtering HIGH impact variants..."

java -jar ~/snpEff/SnpSift.jar filter \
"ANN[*].IMPACT = 'HIGH'" \
"$VCF_IN" > high_impact.vcf
