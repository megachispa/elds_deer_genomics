#!/bin/bash
#SBATCH --job-name=annotate_all
#SBATCH --output=annotate_all_%j.out
#SBATCH --error=annotate_all_%j.err
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

# Activate conda environment
source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate snpeff_env

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR"

VCF=/mnt/tank/scratch/ebarabanova/missingness_calculations/final_missingness_filtered.vcf.gz

# Annotate full VCF
snpEff -v deer "$VCF" | bgzip -c > annotated_genomewide.vcf.gz

# Index annotated VCF
tabix -p vcf annotated_genomewide.vcf.gz

# Extract HIGH-impact variants
bcftools view -i 'INFO/ANN ~ "HIGH"' annotated_genomewide.vcf.gz \
-Oz -o high_impact_genomewide.vcf.gz

# Index HIGH-impact VCF
bcftools index high_impact_genomewide.vcf.gz
