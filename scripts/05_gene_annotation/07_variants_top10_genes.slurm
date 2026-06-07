#!/bin/bash
#SBATCH --job-name=variants_in_top_islands
#SBATCH --output=variants_in_top_islands_%j.out
#SBATCH --error=variants_in_top_islands_%j.err
#SBATCH --time=10:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

# initialize conda
source /nfs/home/ebarabanova/miniconda3_new/etc/profile.d/conda.sh
conda activate vcf_clean

WORKDIR=/mnt/tank/scratch/ebarabanova/var_in_genes
cd "$WORKDIR" || exit 1


#Extract the variants overlapping the selected ROH islands (+indexing):

bcftools view -R roh_islands_top10.bed /mnt/tank/scratch/ebarabanova/missingness_calculations/final_missingness_filtered.vcf.gz -Oz -o variants_in_top_islands.vcf.gz

bcftools index variants_in_top_islands.vcf.gz
bcftools stats variants_in_top_islands.vcf.gz > top_islands_vcf_stats.txt

bedtools intersect \
    -header \
    -a variants_in_top_islands.vcf.gz \
    -b top_roh_island_genes.gff \
    > variants_in_top_islands_genes.vcf
bcftools stats variants_in_top_islands_genes.vcf > top_islands_genes_variants_stats.txt
