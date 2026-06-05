#!/bin/bash
#SBATCH --job-name=eld_pca_plot
#SBATCH --output=eld_pca_plot_%j.out
#SBATCH --error=eld_pca_plot_%j.err
#SBATCH --time=01:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G

# Go to working directory
cd /mnt/tank/scratch/ebarabanova/heterozygosity

# Activate conda environment
source ~/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

# Run PCA plotting script
Rscript /mnt/tank/scratch/ebarabanova/vcf_filtering_qc/elds_deer_genomics/scripts/03_population_genomics/04_plot_pca.R
